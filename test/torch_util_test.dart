import 'package:flutter_test/flutter_test.dart';
import 'package:light_on_flashlight/flutter_flow/torch_util.dart';

/// 카메라 선택 정책 테스트.
///
/// 이 테스트가 존재하는 이유: 낮은 평점의 원인으로 의심되는 버그는 특정 기기
/// (카메라 0번이 플래시 카메라가 아닌 기기)에서만 재현되는데, 그런 기기를
/// 구할 방법이 없었다. 선택 정책을 순수 함수로 빼두면 그 기기의 카메라 목록을
/// 만들어내는 것으로 충분하다.
void main() {
  const back = TorchCamera(
    id: '0',
    hasFlash: true,
    facing: TorchCamera.facingBack,
  );
  const front = TorchCamera(
    id: '1',
    hasFlash: false,
    facing: TorchCamera.facingFront,
  );

  group('selectTorchCamera', () {
    test('평범한 기기: 플래시 있는 후면 카메라를 고른다', () {
      expect(selectTorchCamera([back, front]), back);
    });

    test('0번이 플래시 없는 전면 카메라여도 후면을 찾아낸다', () {
      // 이것이 원래 버그다. cameraIdList[0] 을 그대로 쓰면 전면 카메라가
      // 잡히고, setTorchMode 가 예외를 던지고, 불은 켜지지 않았다.
      expect(selectTorchCamera([front, back]), back);
    });

    test('후면 카메라가 여럿이어도 플래시 있는 쪽을 고른다', () {
      const backNoFlash = TorchCamera(
        id: '2',
        hasFlash: false,
        facing: TorchCamera.facingBack,
      );
      expect(selectTorchCamera([front, backNoFlash, back]), back);
    });

    test('방향 정보가 없어도 플래시가 있으면 쓴다', () {
      const unknown = TorchCamera(id: '9', hasFlash: true);
      expect(selectTorchCamera([front, unknown]), unknown);
    });

    test('전면에만 플래시가 있으면 그거라도 쓴다', () {
      const frontWithFlash = TorchCamera(
        id: '1',
        hasFlash: true,
        facing: TorchCamera.facingFront,
      );
      expect(selectTorchCamera([frontWithFlash]), frontWithFlash);
    });

    test('플래시 있는 카메라가 없으면 null', () {
      expect(selectTorchCamera([front]), isNull);
    });

    test('카메라 목록이 비어도 죽지 않고 null', () {
      // 이 경우 예전 코드는 cameraIdList[0] 에서 예외를 던졌고, 그 조회가
      // 플러그인 생성자에 있어 플러그인 등록 자체가 실패할 수 있었다.
      expect(selectTorchCamera([]), isNull);
    });

    test('강제 모드에서는 플래시 없는 카메라를 고른다', () {
      // 손에 있는 기기로 "플래시를 못 켜는 기기" 를 재현하기 위한 경로다.
      expect(
        selectTorchCamera([back, front], forceCameraWithoutFlash: true),
        front,
      );
    });

    test('강제 모드인데 전부 플래시가 있으면 null', () {
      expect(
        selectTorchCamera([back], forceCameraWithoutFlash: true),
        isNull,
      );
    });
  });

  group('TorchCamera.fromMap', () {
    test('네이티브가 준 맵을 그대로 읽는다', () {
      final camera = TorchCamera.fromMap(const {
        'id': '0',
        'hasFlash': true,
        'facing': 1,
      });
      expect(camera.id, '0');
      expect(camera.hasFlash, isTrue);
      expect(camera.isBack, isTrue);
    });

    test('빠진 필드는 안전한 기본값으로 떨어진다', () {
      final camera = TorchCamera.fromMap(const {'id': '7'});
      expect(camera.id, '7');
      expect(camera.hasFlash, isFalse);
      expect(camera.facing, isNull);
      expect(camera.facingLabel, '방향 불명');
    });
  });

  group('TorchStatus', () {
    test('오류가 있으면 설명에 포함한다', () {
      const status = TorchStatus(
        cameras: [front],
        error: '플래시를 켤 수 있는 카메라를 찾지 못했습니다.',
      );
      expect(status.describe(), contains('카메라 1개'));
      expect(status.describe(), contains('선택: 없음'));
      expect(status.describe(), contains('오류:'));
    });
  });

  // 진단 상수가 꺼져 있는지는 test/release_guard_test.dart 가 확인한다.
  // 여기서 확인하면 조사용 APK 를 만들 때(진단을 켠 채 build-apk.yml 을
  // 돌릴 때) CI 가 빨개져서 APK 가 나오지 않는다.
}
