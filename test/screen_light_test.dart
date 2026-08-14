import 'package:flutter_test/flutter_test.dart';
import 'package:light_on_flashlight/flutter_flow/internationalization.dart';
import 'package:light_on_flashlight/flutter_flow/torch_util.dart';

/// 플래시가 없는 기기에서 화면을 조명으로 대체하는 기능.
///
/// 이 기능은 **플래시가 없는 기기에서만** 동작하므로 손에 있는 기기로는
/// 확인할 수 없다. 그래서 판단 규칙과 번역 완전성을 테스트로 고정한다.
void main() {
  group('shouldUseScreenLight', () {
    test('플래시 있는 카메라를 찾았으면 화면 조명을 쓰지 않는다', () {
      const back = TorchCamera(
        id: '0',
        hasFlash: true,
        facing: TorchCamera.facingBack,
      );
      expect(shouldUseScreenLight(back), isFalse);
    });

    test('플래시 있는 카메라가 없으면 화면 조명으로 대체한다', () {
      // selectTorchCamera 가 null 을 주는 경우가 곧 이 경우다.
      expect(shouldUseScreenLight(null), isTrue);
    });

    test('플래시 없는 카메라만 있는 기기는 화면 조명으로 간다', () {
      const front = TorchCamera(
        id: '1',
        hasFlash: false,
        facing: TorchCamera.facingFront,
      );
      expect(shouldUseScreenLight(selectTorchCamera([front])), isTrue);
    });

    test('카메라가 아예 없는 기기도 화면 조명으로 간다', () {
      expect(shouldUseScreenLight(selectTorchCamera([])), isTrue);
    });
  });

  // 이 앱은 77개 언어를 지원한다. 안내가 번역되지 않은 언어의 사용자는 왜
  // 화면이 하얘졌는지 알 수 없다. 눈이 좋지 않거나 사양이 낮은 기기를 쓰는
  // 분들이 이 경로로 들어오므로, 한 언어라도 비면 안 된다.
  //
  // kTranslationsMap 은 선언 끝에서 .reduce((a, b) => a..addAll(b)) 로
  // 평탄화되므로, 페이지별 구획이 아니라 키 하나로 바로 찾는다.
  //
  // 안내 창은 본문과 확인 버튼 두 개의 문구로 이루어진다. 버튼이 번역되지
  // 않으면 창을 닫는 방법을 알 수 없으므로 본문과 똑같이 취급한다.
  const keys = {
    'n4v8t2q6': '안내 본문',
    'q7w3e5r1': '확인 버튼',
  };

  keys.forEach((key, label) {
    group('$label 번역 ($key)', () {
      Map<String, String>? entry() => kTranslationsMap[key];

      test('키가 번역 지도에 있다', () {
        expect(entry(), isNotNull);
      });

      test('지원하는 모든 언어에 번역이 있다', () {
        final translations = entry()!;
        final missing = FFLocalizations.languages()
            .where((lang) => !translations.containsKey(lang))
            .toList();
        expect(missing, isEmpty, reason: '번역이 빠진 언어: $missing');
      });

      test('빈 번역이 없다', () {
        final translations = entry()!;
        final blank = translations.entries
            .where((e) => e.value.trim().isEmpty)
            .map((e) => e.key)
            .toList();
        expect(blank, isEmpty, reason: '번역이 비어 있는 언어: $blank');
      });
    });
  });

  group('안내 본문은 한국어 복사가 아니어야 한다', () {
    test('원문 그대로 들어간 언어가 없다', () {
      // 번역을 채운다고 한국어를 그대로 붙여 넣으면 안 채운 것과 같다.
      // 확인 버튼은 'OK' 처럼 여러 언어가 같은 표기를 쓰는 것이 정상이라
      // 이 검사를 본문에만 적용한다.
      final translations = kTranslationsMap['n4v8t2q6']!;
      final korean = translations['ko']!;
      final copied = translations.entries
          .where((e) => e.key != 'ko' && e.value == korean)
          .map((e) => e.key)
          .toList();
      expect(copied, isEmpty, reason: '한국어가 그대로 들어간 언어: $copied');
    });
  });
}
