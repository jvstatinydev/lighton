import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:google_mobile_ads/google_mobile_ads.dart';
export 'package:google_mobile_ads/google_mobile_ads.dart';

// Learn more about displaying interstitial ads:
// https://developers.google.com/admob/flutter/interstitial

InterstitialAd? _interstitialAd;
String? _loadingInterstitialAdUnitId;

void loadInterstitialAd(
  String iosAdUnitId,
  String androidAdUnitId,
  bool showTestAds,
) {
  if (kIsWeb) {
    print('AdMob is not supported on web.');
    return;
  }
  String adUnitId;
  if (Platform.isIOS) {
    adUnitId =
        showTestAds ? 'ca-app-pub-3940256099942544/4411468910' : iosAdUnitId;
  } else if (Platform.isAndroid) {
    adUnitId = showTestAds
        ? 'ca-app-pub-3940256099942544/1033173712'
        : androidAdUnitId;
  } else {
    print("AdMob is not supported on this platform.");
    return;
  }

  if (adUnitId == _loadingInterstitialAdUnitId) {
    // Already loading the same ad.
    return;
  }
  if (adUnitId == _interstitialAd?.adUnitId) {
    // The ad is already loaded.
    return;
  }
  _loadingInterstitialAdUnitId = adUnitId;

  InterstitialAd.load(
    adUnitId: adUnitId,
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        if (adUnitId == _loadingInterstitialAdUnitId) {
          _interstitialAd = ad;
          _loadingInterstitialAdUnitId = null;
        }
      },
      onAdFailedToLoad: (LoadAdError error) {
        print('Interstitial ad failed to load: $error');
        _loadingInterstitialAdUnitId = null;
      },
    ),
  );
}

Future<bool> showInterstitialAd() async {
  if (_interstitialAd == null) {
    print('Interstitial ad is not loaded.');
    // Return success even if the ad is not yet loaded.
    // The ad waits for the user, so the user never waits for the ad!
    // https://youtu.be/r2RgFD3Apyo?t=188
    return true;
  }
  final completer = Completer<bool>();
  _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
      _interstitialAd = null;
      completer.complete(true);
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      _interstitialAd = null;
      completer.complete(false);
    },
  );
  _interstitialAd!.show();
  return completer.future;
}

// EEA(유럽 경제 지역) 사용자에게 AdMob이 요구하는 UMP 동의 흐름 + 광고 SDK 초기화.
// https://developers.google.com/admob/flutter/privacy
//
// 이 흐름이 끝나야 광고를 요청할 수 있다. AdMob 문서가 못박고 있듯이
// "Before loading ads, initialize ... by calling MobileAds.instance.initialize()"
// 이고, canRequestAds() 는 requestConsentInfoUpdate() 가 끝나기 전까지 항상
// false 다. 그래서 배너는 초기화를 기다리지 않고 첫 프레임에 광고를 요청하면
// 안 되고, ensureAdMobReady() 를 await 한 뒤에 요청해야 한다.

/// 광고 준비 과정에서 어느 단계까지 갔는지를 담는다.
///
/// adb 를 쓸 수 없어 logcat 을 볼 수 없으므로(CLAUDE.md 의 `adb` 항목 참고)
/// 기기에서 실패 원인을 읽으려면 이 값을 위젯 트리에 그리는 수밖에 없다.
class AdMobReadiness {
  const AdMobReadiness({
    required this.consent,
    required this.status,
    required this.canRequestAds,
    required this.initialized,
    this.error,
  });

  /// 동의 수집 단계의 결과를 사람이 읽을 수 있게 적은 것.
  final String consent;

  /// UMP 가 보고한 동의 상태.
  final String status;

  /// 광고를 요청해도 되는지. false 면 배너는 요청 자체를 하지 않는다.
  final bool canRequestAds;

  /// MobileAds.instance.initialize() 가 성공했는지.
  final bool initialized;

  /// 초기화나 상태 조회에서 난 예외.
  final String? error;

  String describe() => [
        '동의: $consent',
        '상태: $status',
        'canRequestAds: $canRequestAds',
        'SDK 초기화: ${initialized ? '성공' : '실패'}',
        if (error != null) '오류: $error',
      ].join('\n');
}

const AdMobReadiness _pending = AdMobReadiness(
  consent: '확인 전',
  status: '확인 전',
  canRequestAds: false,
  initialized: false,
);

/// 광고 준비 결과. 배너가 실패 사유를 화면에 그릴 때 읽는다.
AdMobReadiness adMobReadiness = _pending;

Future<void>? _ready;

/// 동의 수집과 광고 SDK 초기화를 한 번만 수행하고, 끝나면 완료되는 Future.
///
/// 절대 예외를 던지지 않는다. 동의를 거부하든 네트워크가 없든 앱의 나머지
/// 기능(손전등)은 그대로 동작해야 하므로, main() 은 이걸 기다리지 않아도 된다.
/// 반대로 광고를 요청하는 위젯은 반드시 이걸 await 한 뒤에 요청해야 한다.
Future<void> ensureAdMobReady() {
  if (kIsWeb) {
    debugPrint('AdMob is not supported on web.');
    return Future.value();
  }
  return _ready ??= _prepareAdMob();
}

Future<void> _prepareAdMob() async {
  final consent = await _gatherConsent();

  // 동의 결과와 무관하게 SDK 는 초기화한다. 초기화 자체는 광고 요청이 아니다.
  // 예전에는 이 호출이 canRequestAds() 뒤에 숨어 있어서, 동의 확인이 한 번
  // 실패하면 그 세션 내내 SDK 가 초기화되지 않았다.
  String? error;
  var initialized = false;
  try {
    await MobileAds.instance.initialize();
    initialized = true;
  } catch (e) {
    error = 'initialize: $e';
  }

  // 광고를 실제로 요청해도 되는지는 여기서 따로 판단한다. 동의가 필요한
  // 지역에서 동의를 못 받았으면 요청하지 않는 것이 맞다.
  var canRequestAds = false;
  var status = '조회 실패';
  try {
    canRequestAds = await ConsentInformation.instance.canRequestAds();
    status = (await ConsentInformation.instance.getConsentStatus()).name;
  } catch (e) {
    error ??= 'consent 조회: $e';
  }

  adMobReadiness = AdMobReadiness(
    consent: consent,
    status: status,
    canRequestAds: canRequestAds,
    initialized: initialized,
    error: error,
  );
  debugPrint('AdMob readiness:\n${adMobReadiness.describe()}');
}

/// 동의 정보를 갱신하고, 필요한 경우 동의 양식을 띄운다.
///
/// 성공/실패와 관계없이 결과를 설명하는 문자열로 완료된다. 콜백이 영영 오지
/// 않는 경우에도 광고 로드가 영구히 막히지 않도록 상한을 둔다.
Future<String> _gatherConsent() {
  final completer = Completer<String>();
  void finish(String outcome) {
    if (!completer.isCompleted) {
      completer.complete(outcome);
    }
  }

  try {
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        // 동의가 필요한 지역에서만 양식이 뜬다. 필요 없으면 바로 콜백된다.
        try {
          await ConsentForm.loadAndShowConsentFormIfRequired(
            (FormError? error) => finish(error == null
                ? '완료'
                : '양식 실패 [${error.errorCode}] ${error.message}'),
          );
        } catch (e) {
          finish('양식 예외: $e');
        }
      },
      (FormError error) =>
          finish('갱신 실패 [${error.errorCode}] ${error.message}'),
    );
  } catch (e) {
    finish('요청 예외: $e');
  }

  return completer.future.timeout(
    const Duration(seconds: 15),
    onTimeout: () => '시간 초과(15초)',
  );
}

void adMobUpdateRequestConfiguration() {
  if (kIsWeb) {
    print('AdMob is not supported on web.');
    return;
  }
  final RequestConfiguration requestConfiguration = RequestConfiguration();
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
}
