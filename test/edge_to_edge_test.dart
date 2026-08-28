import 'package:flutter/foundation.dart' show DebugPrintCallback, debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_on_flashlight/flutter_flow/edge_to_edge_util.dart';

/// 주어진 MediaQuery 아래에서 [SystemInsets.of] 가 읽는 값을 돌려준다.
///
/// [padding] 을 따로 줄 수 있게 해 둔 것은 키보드 때문이다. 키보드가 올라오면
/// 프레임워크가 padding 의 아래쪽만 0 으로 깎고 viewPadding 은 그대로 둔다.
Future<SystemInsets> read(
  WidgetTester tester, {
  required Size size,
  required EdgeInsets viewPadding,
  EdgeInsets? padding,
  EdgeInsets viewInsets = EdgeInsets.zero,
}) async {
  late SystemInsets got;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: size,
        viewPadding: viewPadding,
        padding: padding ?? viewPadding,
        viewInsets: viewInsets,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (BuildContext context) {
            got = SystemInsets.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return got;
}

void main() {
  setUp(resetSystemInsetsLog);

  group('SystemInsets', () {
    testWidgets('시스템 바가 먹은 폭을 그대로 읽는다', (WidgetTester tester) async {
      final SystemInsets insets = await read(
        tester,
        size: const Size(411, 914),
        viewPadding: const EdgeInsets.only(top: 48.0, bottom: 24.0),
      );

      expect(insets.top, 48.0);
      expect(insets.bottom, 24.0);
      expect(insets.left, 0.0);
      expect(insets.right, 0.0);
      expect(insets.isPortrait, isTrue);
    });

    testWidgets('키보드가 올라와도 내비게이션 바 폭은 그대로 읽는다',
        (WidgetTester tester) async {
      // 키보드가 뜨면 프레임워크가 padding 의 아래쪽을 0 으로 깎는다.
      // padding 을 읽으면 여기서 0 이 나오고, 그러면 "내비게이션 바가 몇 dp 를
      // 먹었나" 라는 질문에 키보드 상태에 따라 다른 답이 나온다.
      final SystemInsets insets = await read(
        tester,
        size: const Size(411, 914),
        viewPadding: const EdgeInsets.only(top: 48.0, bottom: 24.0),
        padding: const EdgeInsets.only(top: 48.0),
        viewInsets: const EdgeInsets.only(bottom: 300.0),
      );

      expect(insets.top, 48.0);
      expect(insets.bottom, 24.0);
    });

    testWidgets('가로에서는 옆으로 붙은 내비게이션 바도 읽는다',
        (WidgetTester tester) async {
      // 가로가 세로보다 확인할 것이 많다. 내비게이션 바가 옆으로 오고
      // 디스플레이 컷아웃이 화면 옆면으로 들어오기 때문에, 세로에서는 늘
      // 0 이던 left/right 가 0 이 아니게 된다. Play Console 의 edge-to-edge
      // 경고가 실제 문제인 경우, 대개 여기서 드러난다.
      final SystemInsets insets = await read(
        tester,
        size: const Size(914, 411),
        viewPadding: const EdgeInsets.only(left: 48.0, right: 24.0),
      );

      expect(insets.left, 48.0);
      expect(insets.right, 24.0);
      expect(insets.isPortrait, isFalse);
    });

    testWidgets('describe() 는 네 방향을 모두 담는다', (WidgetTester tester) async {
      final SystemInsets insets = await read(
        tester,
        size: const Size(411, 914),
        viewPadding: const EdgeInsets.fromLTRB(1.0, 2.0, 3.0, 4.0),
      );

      final String text = insets.describe();
      expect(text, contains('상단 2.0dp'));
      expect(text, contains('하단 4.0dp'));
      expect(text, contains('좌 1.0dp'));
      expect(text, contains('우 3.0dp'));
      expect(text, contains('세로'));
    });
  });

  group('logSystemInsets', () {
    testWidgets('같은 값은 다시 찍지 않는다', (WidgetTester tester) async {
      // build 에서 부르므로 프레임마다 같은 줄이 쌓이면 logcat 에서 정작
      // 볼 것을 밀어낸다. emulator-check.yml 이 읽는 파일이 그렇게 되면
      // 진단으로서 쓸모가 없어진다.
      Future<void> pumpWith(EdgeInsets viewPadding) => tester.pumpWidget(
            MediaQuery(
              data: MediaQueryData(
                size: const Size(411, 914),
                viewPadding: viewPadding,
                padding: viewPadding,
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Builder(
                  builder: (BuildContext context) {
                    logSystemInsets(context);
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );

      // debugPrint 는 테스트 본문이 끝나기 *전에* 되돌려야 한다. flutter_test
      // 가 본문 직후에 foundation 디버그 변수가 원래대로인지 검사하므로,
      // addTearDown 으로 미루면 그 검사에 걸린다.
      final List<String> lines = <String>[];
      final DebugPrintCallback original = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) {
          lines.add(message);
        }
      };
      try {
        await pumpWith(const EdgeInsets.only(top: 48.0, bottom: 24.0));
        expect(lines.length, 1);

        // 같은 값으로 다시 그려도 늘지 않는다.
        await pumpWith(const EdgeInsets.only(top: 48.0, bottom: 24.0));
        await tester.pump();
        expect(lines.length, 1);

        // 방향이 바뀌면(= 값이 바뀌면) 한 번 더 찍힌다.
        await pumpWith(const EdgeInsets.only(left: 48.0));
        expect(lines.length, 2);
        expect(lines.last, startsWith('System insets:'));
      } finally {
        debugPrint = original;
      }
    });
  });
}
