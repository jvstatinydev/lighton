import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'admob_util.dart' show adMobReadiness, ensureAdMobReady;
import 'remove_ads_promo.dart'
    show RemoveAdsButton, RemoveAdsInlinePromo, kInlineRemoveAdsMinWidth;

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
    this.showInlineButton = true,
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

  /// 배너 왼쪽 여백에 "광고 제거" 버튼을 둘지.
  ///
  /// 자리가 모자라면 이 값이 true 여도 그리지 않는다. 그때는 홈 화면이
  /// 같은 버튼을 상단바에 올린다.
  final bool showInlineButton;

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

    // 크기를 화면에 맞춰 계산하지 않고 320x50 으로 고정한다.
    //
    // 어댑티브 배너는 화면 방향과 크기에 따라 높이가 달라진다. 가로모드에서는
    // 화면 높이가 얼마 안 되는데 배너가 세로 자리를 가져가서 손전등 버튼이
    // 위아래로 짜부라졌다. 방향을 바꿀 때마다 배너를 다시 받아야 하는 것도
    // 그 때문이었다.
    //
    // 고정 크기면 세로든 가로든 같은 높이의 막대 하나다. 버튼이 쓸 수 있는
    // 자리가 방향에 따라 흔들리지 않고, 회전해도 다시 받을 필요가 없다.
    // 320x50 은 가장 오래된 규격이라 채워지는 광고도 가장 많다.
    final AdSize size = widget.width != null && widget.height != null
        ? AdSize(
            height: widget.height!.toInt(),
            width: widget.width!.toInt(),
          )
        : AdSize.banner;

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
    // 광고를 포기했다는 사실은 따로 들고 있지 않아도 된다. 배너가 없으면
    // 그 자리에 프로모가 나오는데, 로딩 중이든 최종 실패든 마찬가지다.
    setState(() => _failure = reason);
  }

  @override
  Widget build(BuildContext context) {
    if (kShowAdBannerDiagnostics) {
      return _diagnostics();
    }

    // 화면을 조명으로 쓰는 동안에는 자리만 남기고 아무것도 그리지 않는다.
    // 글자든 버튼이든 흰 화면에 얹으면 빛을 깎아먹고, 화면을 등지고 비추는
    // 상황이라 볼 사람도 없다. 조명을 끄면 다시 나온다.
    if (widget.hideAd) {
      return Container(
        width: double.infinity,
        height: AdSize.banner.height.toDouble(),
        color: Colors.white,
      );
    }

    final banner = _banner;
    final adWidget = _adWidget;

    // 높이는 광고가 있든 없든 같다. 광고가 늦게 도착해도 화면이 출렁이지 않는다.
    return SizedBox(
      height: AdSize.banner.height.toDouble(),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool roomForButton =
              widget.showInlineButton && constraints.maxWidth >= kInlineRemoveAdsMinWidth;

          final Widget slot = banner != null && adWidget != null
              ? SizedBox(
                  width: banner.size.width.toDouble(),
                  height: banner.size.height.toDouble(),
                  child: adWidget,
                )
              // 광고가 아직 안 왔거나 끝내 실패했다. 예전에는 이 자리가 통째로
              // 비어 있었는데, 광고 하나 뜨는 데 걸리는 그 시간 동안 화면에
              // 아무것도 없어서 기다리다 앱을 닫는 일이 실제로 있었다.
              // 그 순간이 "광고 없이 쓰기"를 제안하기 가장 좋은 때다.
              : const Expanded(child: RemoveAdsInlinePromo());

          return Row(
            children: [
              if (roomForButton) ...[
                const RemoveAdsButton(),
                // 버튼과 광고 사이의 죽은 공간. 버튼을 노리다 광고를 잘못
                // 누르면 무효 클릭이 되므로 반드시 띄워 둔다.
                const SizedBox(width: 8.0),
              ],
              if (banner != null && adWidget != null) const Spacer(),
              slot,
            ],
          );
        },
      ),
    );
  }

  Widget _diagnostics() {
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
