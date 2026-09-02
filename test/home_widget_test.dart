import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride, TargetPlatform;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_on_flashlight/flutter_flow/home_widget_util.dart';

/// 홈 화면 위젯 채널의 Dart 쪽.
///
/// 위젯 자체는 네이티브라 여기서 그릴 수 없다. 여기서 지키는 것은 채널이
/// 약속한 문자열(WidgetPlugin.kt, TorchWidgetProvider.kt 와 짝)과, 채널이
/// 없거나 실패해도 앱이 죽지 않는다는 것이다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('lighton/widgets');
  final TestDefaultBinaryMessenger messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    // 이 유틸은 Android 에서만 동작한다. 테스트는 리눅스에서 도니 흉내 낸다.
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    pendingWidgetLaunchAction.value = WidgetLaunchAction.none;
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    messenger.setMockMethodCallHandler(channel, null);
  });

  group('parseWidgetLaunchAction', () {
    test('네이티브가 쓰는 문자열을 그대로 받는다', () {
      // TorchWidgetProvider.LAUNCH_REMOVE_ADS / LAUNCH_TOGGLE 과 같은 값.
      expect(
        parseWidgetLaunchAction('removeAds'),
        WidgetLaunchAction.removeAds,
      );
      expect(parseWidgetLaunchAction('toggle'), WidgetLaunchAction.toggle);
    });

    test('모르는 값과 null 은 none', () {
      expect(parseWidgetLaunchAction(null), WidgetLaunchAction.none);
      expect(parseWidgetLaunchAction(''), WidgetLaunchAction.none);
      expect(parseWidgetLaunchAction('buy'), WidgetLaunchAction.none);
    });
  });

  group('refreshHomeWidgets', () {
    test('refresh 를 부른다', () async {
      final List<String> calls = <String>[];
      messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
        calls.add(call.method);
        return null;
      });
      await refreshHomeWidgets();
      expect(calls, <String>['refresh']);
    });

    test('네이티브가 없어도(채널 미구현) 예외를 던지지 않는다', () async {
      // 핸들러를 안 걸면 MissingPluginException 이 난다. 웹이나 iOS 빌드,
      // 혹은 네이티브가 채널을 열기 전이 이 경우다.
      await expectLater(refreshHomeWidgets(), completes);
    });

    test('네이티브가 실패해도 예외를 던지지 않는다', () async {
      messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
        throw PlatformException(code: 'boom');
      });
      await expectLater(refreshHomeWidgets(), completes);
    });

    test('Android 가 아니면 채널을 건드리지 않는다', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      bool called = false;
      messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
        called = true;
        return null;
      });
      await refreshHomeWidgets();
      expect(called, isFalse);
    });
  });

  group('consumeWidgetLaunchAction', () {
    test('네이티브가 준 값을 해석한다', () async {
      messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
        expect(call.method, 'consumeLaunchAction');
        return 'removeAds';
      });
      expect(await consumeWidgetLaunchAction(), WidgetLaunchAction.removeAds);
    });

    test('아무것도 없으면 none', () async {
      messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
        return null;
      });
      expect(await consumeWidgetLaunchAction(), WidgetLaunchAction.none);
    });

    test('채널이 없어도 none', () async {
      expect(await consumeWidgetLaunchAction(), WidgetLaunchAction.none);
    });
  });

  group('launchAction (네이티브 → Dart)', () {
    test('밀어 넣은 동작이 pendingWidgetLaunchAction 에 실린다', () async {
      initHomeWidgetChannel();
      final ByteData? message = const StandardMethodCodec().encodeMethodCall(
        const MethodCall('launchAction', 'toggle'),
      );
      await messenger.handlePlatformMessage(
        channel.name,
        message,
        (ByteData? reply) {},
      );
      expect(pendingWidgetLaunchAction.value, WidgetLaunchAction.toggle);
    });

    test('모르는 메서드는 무시한다', () async {
      initHomeWidgetChannel();
      final ByteData? message = const StandardMethodCodec().encodeMethodCall(
        const MethodCall('somethingElse', 'x'),
      );
      await messenger.handlePlatformMessage(
        channel.name,
        message,
        (ByteData? reply) {},
      );
      expect(pendingWidgetLaunchAction.value, WidgetLaunchAction.none);
    });
  });
}
