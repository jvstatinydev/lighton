import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admob_util.dart' show adMobReadiness, ensureAdMobReady;
import 'remove_ads_promo.dart' show RemoveAdsPromo;

/// 몇 번에 한 번 배너 대신 "광고 제거" 프로모를 띄울지.
///
/// 프로모가 뜨는 실행에서는 광고를 **아예 요청하지 않는다.** 이미 로드된
/// 광고를 다른 것으로 가리면 AdMob 정책 위반이므로, 요청 전에 정해야 한다.
/// 그만큼 광고 노출을 포기하는 것이고, 5면 20%다.
const int _kPromoEveryNLaunches = 5;

const String _kLaunchCountKey = '__banner_launch_count__';

/// 이번 실행이 프로모 차례인지. 프로세스당 한 번만 정한다.
///
/// 위젯의 initState 가 아니라 여기서 세는 이유는, 언어를 바꾸면 라우터가
/// 페이지를 다시 만들어 initState 가 한 실행 안에서 여러 번 돌 수 있기
/// 때문이다. 그러면 "실행 횟수"가 아니라 "위젯 생성 횟수"를 세게 된다.
bool? _promoSessionDecision;

Future<bool> _isPromoSession() async {
  final bool? decided = _promoSessionDecision;
  if (decided != null) {
    return decided;
  }
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int count = (prefs.getInt(_kLaunchCountKey) ?? 0) + 1;
    await prefs.setInt(_kLaunchCountKey, count);
    return _promoSessionDecision = count % _kPromoEveryNLaunches == 0;
  } catch (_) {
    // 저장소를 못 읽으면 광고를 띄우는 쪽으로 넘어간다.
    return _promoSessionDecision = false;
  }
}

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

  /// 이번 실행은 광고 대신 프로모를 띄우는 차례다.
  bool _promoSession = false;

  /// 재시도까지 다 쓰고 광고를 포기했다. 이 자리를 비워두느니 프로모를 그린다.
  bool _gaveUp = false;

  int _attempt = 0;
  bool _loading = false;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (await _isPromoSession()) {
        if (mounted) {
          setState(() => _promoSession = true);
        }
        // 광고를 요청하지 않는다. 로드해놓고 가리면 정책 위반이다.
        return;
      }
      if (mounted) {
        await _load();
      }
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
    setState(() {
      _failure = reason;
      _gaveUp = true;
    });
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
      // 프로모 차례이거나, 광고를 끝내 못 띄웠을 때. 후자는 예전에는 그냥
      // 빈 공간으로 접혔는데, 어차피 광고가 없는 자리이므로 잃을 것이 없다.
      // 그리고 이 두 경우가 사용자가 "구매 복원"에 닿을 수 있는 통로다.
      if (_promoSession || _gaveUp) {
        return const RemoveAdsPromo();
      }
      // 아직 로딩 중이면 자리를 차지하지 않는다.
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
