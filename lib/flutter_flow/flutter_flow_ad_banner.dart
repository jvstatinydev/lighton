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
const bool kShowAdBannerDiagnostics = true;

class FlutterFlowAdBanner extends StatefulWidget {
  const FlutterFlowAdBanner({
    Key? key,
    this.width,
    this.height,
    required this.showsTestAd,
    this.iOSAdUnitID,
    this.androidAdUnitID,
  }) : super(key: key);

  final double? width;
  final double? height;
  final bool showsTestAd;
  final String? iOSAdUnitID;
  final String? androidAdUnitID;

  @override
  _FlutterFlowAdBannerState createState() => _FlutterFlowAdBannerState();
}

class _FlutterFlowAdBannerState extends State<FlutterFlowAdBanner> {
  static const AdRequest request = AdRequest();

  /// 로드 실패 시 재시도 횟수 상한. 지연은 2초부터 두 배씩(2/4/8초).
  static const int _maxAttempts = 4;

  BannerAd? _banner;
  AdWidget? _adWidget;

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

    // 화면 크기는 await 전에 읽어둔다. await 뒤에 context 를 다시 만지면
    // 위젯이 사라진 뒤일 수 있다.
    final screen = MediaQuery.sizeOf(context);

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

    final AdSize? size = widget.width != null && widget.height != null
        ? AdSize(
            height: widget.height!.toInt(),
            width: widget.width!.toInt(),
          )
        : await AdSize.getLargeAnchoredAdaptiveBannerAdSizeWithOrientation(
            widget.width == null ? Orientation.portrait : Orientation.landscape,
            widget.width == null
                ? screen.width.truncate()
                : screen.height.truncate(),
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
        child: adWidget,
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
