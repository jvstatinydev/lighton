import 'package:flutter/foundation.dart'
    show
        TargetPlatform,
        ValueNotifier,
        debugPrint,
        defaultTargetPlatform,
        kIsWeb;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 홈 화면 위젯(Android)과 Dart 사이의 다리. 네이티브 쪽은 WidgetPlugin.kt.
///
/// 위젯 자체는 Flutter 가 그리지 않는다. 런처가 그리는 네이티브 뷰라서
/// (android/app/src/main/res/layout/widget_torch_*.xml) Dart 가 할 일은 셋뿐이다.
///
///  1. 구매 상태나 언어가 바뀌면 위젯을 다시 그리라고 알린다([refreshHomeWidgets]).
///     위젯은 shared_preferences 에 저장된 값을 직접 읽으므로, 값을 바꾼 뒤
///     한 번 찔러 주기만 하면 된다.
///  2. 위젯이 앱을 띄우며 넘긴 동작을 받는다([WidgetLaunchAction]). 잠긴 위젯을
///     누르면 결제 시트를 열어야 하고, 플래시 없는 기기의 위젯을 누르면 화면
///     조명을 켜야 한다.
///  3. 구매한 사람에게 알림 권한을 한 번 묻는다([ensureWidgetNotificationPermission]).
///     위젯으로 켠 손전등은 "켜짐, 눌러서 끄기" 알림으로만 화면 밖에서 보이는데,
///     Android 13+ 는 이 권한이 없으면 그 알림을 숨긴다. 위젯을 누르는 순간엔
///     앱이 떠 있지 않아 물을 수 없으므로 앱 안에서 미리 물어 둔다.
const MethodChannel _channel = MethodChannel('lighton/widgets');

/// 알림 권한을 이미 물어봤다는 표시. shared_preferences 키.
const String kWidgetNotificationAskedKey = '__widget_notification_asked__';

/// 위젯이 앱을 띄우며 넘긴 동작. 문자열 값은 TorchWidgetProvider.kt 와 짝이다.
enum WidgetLaunchAction {
  /// 위젯이 띄운 것이 아니거나, 이미 처리했다.
  none,

  /// 잠긴 위젯을 눌렀다. "광고 제거" 결제 시트를 연다.
  removeAds,

  /// 플래시가 없는 기기에서 위젯을 눌렀다. 위젯은 화면을 밝힐 수 없으므로
  /// 앱이 대신 화면 조명을 토글한다.
  toggle,
}

/// 네이티브가 넘긴 문자열을 [WidgetLaunchAction] 으로. 모르는 값은 [WidgetLaunchAction.none].
WidgetLaunchAction parseWidgetLaunchAction(String? raw) => switch (raw) {
  'removeAds' => WidgetLaunchAction.removeAds,
  'toggle' => WidgetLaunchAction.toggle,
  _ => WidgetLaunchAction.none,
};

/// 앱이 떠 있는 채로 위젯이 또 눌렸을 때 네이티브가 밀어 넣는 동작.
///
/// 콜드 스타트는 페이지가 뜬 뒤 [consumeWidgetLaunchAction] 으로 가져가고,
/// 웜 스타트(onNewIntent)는 여기로 온다. 홈 페이지가 듣고 있다가 처리한 뒤
/// [WidgetLaunchAction.none] 으로 되돌린다.
final ValueNotifier<WidgetLaunchAction> pendingWidgetLaunchAction =
    ValueNotifier<WidgetLaunchAction>(WidgetLaunchAction.none);

bool get _supported =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

/// 네이티브 → Dart 호출을 받기 시작한다. main() 에서 한 번 부른다.
void initHomeWidgetChannel() {
  if (!_supported) {
    return;
  }
  _channel.setMethodCallHandler((MethodCall call) async {
    if (call.method == 'launchAction') {
      pendingWidgetLaunchAction.value = parseWidgetLaunchAction(
        call.arguments as String?,
      );
    }
  });
}

/// 놓여 있는 위젯을 전부 다시 그리게 한다. 절대 예외를 던지지 않는다.
///
/// 구매 상태(billing_util.dart)나 언어(main.dart 의 setLocale)가 바뀐 직후에
/// 부른다. 위젯이 하나도 없으면 네이티브가 아무 일도 하지 않는다.
Future<void> refreshHomeWidgets() async {
  if (!_supported) {
    return;
  }
  try {
    await _channel.invokeMethod<void>('refresh');
  } catch (e) {
    debugPrint('HomeWidget: 위젯 갱신 실패: $e');
  }
}

/// 위젯이 앱을 띄우며 넘긴 동작을 한 번 읽고 지운다. 없으면 [WidgetLaunchAction.none].
Future<WidgetLaunchAction> consumeWidgetLaunchAction() async {
  if (!_supported) {
    return WidgetLaunchAction.none;
  }
  try {
    final String? raw = await _channel.invokeMethod<String>(
      'consumeLaunchAction',
    );
    return parseWidgetLaunchAction(raw);
  } catch (e) {
    debugPrint('HomeWidget: 실행 동작 조회 실패: $e');
    return WidgetLaunchAction.none;
  }
}

/// 위젯으로 켠 손전등의 알림이 보이도록 Android 13+ 의 알림 권한을 묻는다.
///
/// 광고 제거를 산(또는 복원한) 사람에게만 의미가 있으니 홈 페이지가 구매 상태를
/// 보고 부른다. 이미 허용돼 있으면 창 없이 true 를 돌려준다. 한 번 물어본
/// 뒤에는 허용이든 거부든 다시 묻지 않는다([kWidgetNotificationAskedKey]).
/// 시스템은 두 번째 거부 뒤 창을 아예 띄우지 않고, 같은 창을 앱을 열 때마다
/// 되풀이해 보여 주고 싶지도 않다. 절대 예외를 던지지 않는다.
Future<bool> ensureWidgetNotificationPermission() async {
  if (!_supported) {
    return false;
  }
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(kWidgetNotificationAskedKey) ?? false) {
      return false;
    }
    // 창을 띄우기 전에 표시한다. 페이지 로드와 시트 닫힘이 겹쳐 두 번 불려도
    // 창은 한 번만 뜬다.
    await prefs.setBool(kWidgetNotificationAskedKey, true);
    final bool granted =
        await _channel.invokeMethod<bool>('requestNotificationPermission') ??
        false;
    debugPrint('HomeWidget: 알림 권한 ${granted ? '허용' : '거부'}');
    return granted;
  } catch (e) {
    debugPrint('HomeWidget: 알림 권한 요청 실패: $e');
    return false;
  }
}
