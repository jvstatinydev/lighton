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

// EEA(유럽 경제 지역) 사용자에게 AdMob이 요구하는 UMP 동의 흐름.
// https://developers.google.com/admob/flutter/privacy
//
// 앱 시작 시 한 번 호출한다(lib/main.dart). 진행 순서는
//   1) 동의 정보 갱신 요청
//   2) 동의가 필요한 지역이면 동의 양식 표시
//   3) 광고를 요청해도 되는 상태이면 광고 SDK 초기화
// 이며, 어느 단계가 실패해도 예외를 던지지 않고 로그만 남긴다.
// 동의 여부나 네트워크 상태와 무관하게 앱의 나머지 기능(손전등)은 그대로
// 동작해야 하므로, 호출 측은 이 Future를 기다리지 않아도 된다.
Future<void> adMobRequestConsent() async {
  if (kIsWeb) {
    debugPrint('AdMob is not supported on web.');
    return;
  }

  await _gatherConsent();
  await _initializeAdsIfAllowed();
}

/// 동의 정보를 갱신하고, 필요한 경우 동의 양식을 띄운다.
///
/// 성공/실패 여부와 관계없이 흐름이 끝나면 완료되는 Future를 돌려준다.
Future<void> _gatherConsent() {
  final completer = Completer<void>();
  void finish() {
    if (!completer.isCompleted) {
      completer.complete();
    }
  }

  ConsentInformation.instance.requestConsentInfoUpdate(
    ConsentRequestParameters(),
    () async {
      // 동의가 필요한 지역에서만 양식이 뜬다. 필요 없으면 바로 콜백된다.
      try {
        await ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
          if (error != null) {
            debugPrint(
                'AdMob consent form failed: [${error.errorCode}] ${error.message}');
          }
          finish();
        });
      } catch (e) {
        debugPrint('AdMob consent form threw: $e');
        finish();
      }
    },
    (FormError error) {
      debugPrint(
          'AdMob consent info update failed: [${error.errorCode}] ${error.message}');
      finish();
    },
  );

  return completer.future;
}

/// 동의 결과상 광고 요청이 허용될 때만 광고 SDK를 초기화한다.
Future<void> _initializeAdsIfAllowed() async {
  try {
    if (await ConsentInformation.instance.canRequestAds()) {
      await MobileAds.instance.initialize();
    } else {
      debugPrint('AdMob: consent not obtained, skipping ads initialization.');
    }
  } catch (e) {
    debugPrint('AdMob initialization failed: $e');
  }
}

void adMobUpdateRequestConfiguration() {
  if (kIsWeb) {
    print('AdMob is not supported on web.');
    return;
  }
  final RequestConfiguration requestConfiguration = RequestConfiguration();
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
}
