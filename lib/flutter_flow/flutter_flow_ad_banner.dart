import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_util.dart' show adMobReadiness, ensureAdMobReady;

/// 배너가 광고를 못 띄웠을 때 그 이유를 배너 자리에 글자로 그릴지 여부.
///
/// adb 를 쓸 수 없어 logcat 을 볼 수 없으므로(CLAUDE.md 의 `adb` 항목 참고)
/// 기기에서 실패 원인을 읽으려면 화면에 그리는 방법밖에 없다. `build-apk.yml`
/// 이 만드는 APK 는 release 빌드라 kDebugMode 로는 구분되지 않으니, 조사용
/// 빌드에서 이 상수를 true 로 두고 확인한 뒤 Play 출시 전에 false 로 되돌린다.
/// false 이면 배너 자리는 아무것도 차지하지 않고 접힌다.
const bool kShowAdBannerDiagnostics = false;

class FlutterFlowAdBanner extends StatefulWidget {
  const FlutterFlowAdBanner({
    Key? key,
    this.width,
    this.height,
    required this.showsTestAd,
    this.iOSAdUnitID,
    this.androidAdUnitID,
    this.hideAd = false,
  }) : super(key: key);

  final double? width;
  final double? height;
  final bool showsTestAd;
  final String? iOSAdUnitID;
  final String? androidAdUnitID;

  /// 광고를 감추되 차지하던 자리는 그대로 둔다.
  ///
  /// 화면 조명을 켜면 배너를 감추는데, 위젯을 통째로 빼면 그만큼 레이아웃이
  /// 줄어들면서 화면 전체가 출렁인다. 자리를 유지하고 흰색으로 덮으면
  /// 껐다 켤 때 아무것도 움직이지 않는다.
  ///
  /// AdWidget 자체를 그리지 않으므로, 보이지 않는 광고가 노출로 잡히지도
  /// 않는다. 로드된 배너는 그대로 두어 다시 켤 때 즉시 나타난다.
  final bool hideAd;

  @override
  _FlutterFlowAdBannerState createState() => _FlutterFlowAdBannerState();
}

class _FlutterFlowAdBannerState extends State<FlutterFlowAdBanner> {
  static const AdRequest request = AdRequest();

  /// 로드 실패 시 재시도 횟수 상한. 지연은 2초부터 두 배씩(2/4/8초).
  static const int _maxAttempts = 4;

  BannerAd? _banner;
  AdWidget? _adWidget;

  /// 배너를 로드할 때의 화면 방향. 방향이 바뀌면 크기가 맞지 않는다.
  Orientation? _loadedOrientation;

  /// 화면에 그릴 실패 사유. null 이면 아직 진행 중이라는 뜻이다.
  String? _failure;

  int _attempt = 0;
  bool _loading = false;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 세로에서 계산한 크기를 가로에서 그대로 쓰면 폭이 모자라 좌우가 비고
    // 높이도 어긋난다. 방향이 바뀌면 그 방향에 맞는 크기로 다시 받는다.
    final orientation = MediaQuery.orientationOf(context);
    if (_loadedOrientation != null && _loadedOrientation != orientation) {
      _reloadForOrientation();
    }
  }

  void _reloadForOrientation() {
    _retryTimer?.cancel();
    _banner?.dispose();
    _loadedOrientation = null;
    setState(() {
      _banner = null;
      _adWidget = null;
      _failure = null;
      _attempt = 0;
      _loading = false;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _banner?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (!mounted || _loading) {
      return;
    }
    _loading = true;
    _attempt++;

    // 화면 크기와 방향은 await 전에 읽어둔다. await 뒤에 context 를 다시
    // 만지면 위젯이 사라진 뒤일 수 있다.
    final screen = MediaQuery.sizeOf(context);
    final orientation = MediaQuery.orientationOf(context);

    // 광고를 요청하기 전에 동의 수집과 SDK 초기화가 끝나기를 기다린다.
    // 예전에는 기다리지 않고 첫 프레임에 곧장 요청했고, 초기화가 끝나기 전에
    // 나간 그 한 번의 요청이 실패하면 재시도가 없어 그대로 끝이었다.
    await ensureAdMobReady();
    if (!mounted) {
      _loading = false;
      return;
    }

    // 동의가 필요한 지역에서 동의를 못 받았으면 요청하지 않는 것이 맞다.
    // 이 상태는 세션 중에 바뀌지 않으므로 재시도하지 않고 사유만 남긴다.
    if (!adMobReadiness.canRequestAds) {
      _fail('광고를 요청할 수 없는 상태\n\n${adMobReadiness.describe()}');
      return;
    }

    // 예전에는 "Large" 앵커드 어댑티브 크기를 요청했다. 그 자리는 큰 광고를
    // 담으려고 높게 잡히는데, 실제로 들어오는 광고가 그보다 작으면 큰 상자
    // 안에서 가운데 정렬되어 위아래가 빈다. 광고 아래에 생기던 여백이 그것이다.
    //
    // 게다가 방향 인자가 항상 portrait 로 고정돼 있었다. 이 화면은 width 를
    // 넘기지 않으므로 조건이 늘 참이어서, 가로모드에서도 세로 기준으로
    // 계산됐다. 표준 앵커드 어댑티브 크기를 현재 방향 기준으로 받는다.
    final AdSize? size = widget.width != null && widget.height != null
        ? AdSize(
            height: widget.height!.toInt(),
            width: widget.width!.toInt(),
          )
        : await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            screen.width.truncate(),
          );

    if (size == null) {
      _fail('배너 크기를 계산하지 못했습니다.');
      return;
    }

    final isAndroid = !kIsWeb && Platform.isAndroid;
    final banner = BannerAd(
      size: size,
      request: request,
      adUnitId: widget.showsTestAd
          ? isAndroid
              ? 'ca-app-pub-3940256099942544/6300978111'
              : 'ca-app-pub-3940256099942544/2934735716'
          : isAndroid
              ? widget.androidAdUnitID!
              : widget.iOSAdUnitID!,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _banner = ad as BannerAd;
            _adWidget = AdWidget(ad: ad);
            _loadedOrientation = orientation;
            _failure = null;
            _loading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _retry('광고 로드 실패\n'
              '[코드 ${error.code}] ${error.message}\n'
              'domain: ${error.domain}');
        },
      ),
    );

    await banner.load();
  }

  /// 재시도 여지가 있으면 예약하고, 없으면 사유를 확정해서 남긴다.
  void _retry(String reason) {
    _loading = false;
    if (!mounted) {
      return;
    }
    if (_attempt >= _maxAttempts) {
      _fail('$reason\n\n$_attempt회 재시도 모두 실패');
      return;
    }
    final delay = Duration(seconds: 1 << _attempt);
    setState(() => _failure =
        '$reason\n\n${delay.inSeconds}초 후 재시도 ($_attempt/$_maxAttempts)');
    _retryTimer = Timer(delay, _load);
  }

  void _fail(String reason) {
    _loading = false;
    if (!mounted) {
      return;
    }
    setState(() => _failure = reason);
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;
    final adWidget = _adWidget;
    if (banner != null && adWidget != null) {
      return Container(
        alignment: Alignment.center,
        width: banner.size.width.toDouble(),
        height: banner.size.height.toDouble(),
        // 감출 때는 같은 크기의 흰 자리로 남긴다. 크기가 그대로라 레이아웃이
        // 움직이지 않고, 조명 중에는 배경과 같은 흰색이라 눈에 띄지도 않는다.
        color: widget.hideAd ? Colors.white : null,
        child: widget.hideAd ? null : adWidget,
      );
    }

    if (!kShowAdBannerDiagnostics) {
      // 광고가 없으면 자리를 차지하지 않는다.
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _failure ?? '광고 불러오는 중...',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
