import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/services.dart';

/// 플래시가 없는 기기에서 화면 자체를 조명으로 쓴다.
///
/// 태블릿을 비롯해 플래시가 아예 없는 기기가 적지 않고, 그런 기기에서 이 앱은
/// 여태 버튼만 눌리고 아무 일도 일어나지 않았다. 손전등이 필요한 상황은 대개
/// 급한 상황이므로, 못 켠다고 손 놓는 것보다 화면이라도 밝히는 편이 낫다.
///
/// 네이티브가 창 밝기를 최대로 올리고 화면이 꺼지지 않게 한다. 흰 화면을
/// 그리는 것은 위젯 쪽 몫이다.
const MethodChannel _channel = MethodChannel('lighton/screen_light');

bool _on = false;

/// 화면 조명이 켜져 있는지.
bool get screenLightOn => _on;

/// 화면 조명을 켜거나 끈다. 켜진 뒤의 상태를 돌려준다.
///
/// 예외를 던지지 않는다. 밝기 조절이 실패해도 흰 화면은 그릴 수 있으므로,
/// 실패했다고 기능 전체를 포기하지는 않는다. 어두운 흰 화면이라도 아무것도
/// 없는 것보다는 낫다.
Future<bool> setScreenLight(bool on) async {
  if (kIsWeb) {
    _on = on;
    return _on;
  }
  try {
    await _channel.invokeMethod<bool>('setScreenLight', {'on': on});
  } catch (e) {
    debugPrint('ScreenLight: 밝기 조절 실패: $e');
  }
  _on = on;
  return _on;
}
