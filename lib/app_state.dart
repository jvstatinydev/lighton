import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// "광고 제거" 권한의 저장 키.
const String kAdsRemovedKey = '__ads_removed__';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  SharedPreferences? _prefs;

  Future initializePersistedState() async {
    _prefs = await SharedPreferences.getInstance();
    _adsRemoved = _prefs?.getBool(kAdsRemovedKey) ?? false;
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  bool _isFlashOn = false;
  bool get isFlashOn => _isFlashOn;
  set isFlashOn(bool value) {
    _isFlashOn = value;
  }

  /// 광고를 지울 권한이 있는지.
  ///
  /// 값을 정하는 것은 `flutter_flow/billing_util.dart` 다. Play 에 물어본
  /// 결과만 여기에 들어오고, 이 값은 그 판정의 캐시다. 캐시가 있어야 앱을
  /// 켜자마자 광고 없이 시작할 수 있다 -- Play 조회는 비동기라 첫 프레임에는
  /// 끝나 있지 않다.
  ///
  /// 재설치나 새 기기에는 캐시가 없어 첫 프레임에는 false 다. 조회가 끝나면
  /// 배너가 사라지는 것이 정상이며, 첫 프레임부터 정확할 수는 없다.
  bool _adsRemoved = false;
  bool get adsRemoved => _adsRemoved;
  set adsRemoved(bool value) {
    _adsRemoved = value;
    _prefs?.setBool(kAdsRemovedKey, value);
  }
}
