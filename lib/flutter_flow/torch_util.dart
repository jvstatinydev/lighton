import 'package:flutter/foundation.dart' show debugPrint, immutable, kIsWeb;
import 'package:flutter/services.dart';

import 'screen_light_util.dart';

/// 카메라 목록과 선택 결과를 화면에 그릴지 여부.
///
/// adb 를 쓸 수 없어 logcat 을 볼 수 없으므로(CLAUDE.md 의 `adb` 항목 참고)
/// 기기에서 무슨 일이 있었는지 읽으려면 위젯 트리에 그리는 수밖에 없다.
/// 조사용 빌드에서 true 로 두고 Play 출시 전에 false 로 되돌린다.
const bool kShowTorchDiagnostics = false;

/// 일부러 플래시 없는 카메라를 골라 실패 경로를 재현한다.
///
/// "플래시가 없는 기기" 를 따로 구하지 않아도, 손에 있는 기기의 전면 카메라로
/// 같은 상황을 만들 수 있다. 조사용이며 출시 빌드에서는 반드시 false 여야 한다.
const bool kForceTorchCameraWithoutFlash = false;

const MethodChannel _channel = MethodChannel('lighton/torch');

/// 네이티브가 알려준 카메라 하나.
@immutable
class TorchCamera {
  const TorchCamera({
    required this.id,
    required this.hasFlash,
    this.facing,
  });

  /// Android `CameraCharacteristics.LENS_FACING` 값.
  static const int facingFront = 0;
  static const int facingBack = 1;
  static const int facingExternal = 2;

  final String id;
  final bool hasFlash;
  final int? facing;

  bool get isBack => facing == facingBack;

  static TorchCamera fromMap(Map<Object?, Object?> map) => TorchCamera(
        id: '${map['id']}',
        hasFlash: map['hasFlash'] == true,
        facing: map['facing'] is int ? map['facing'] as int : null,
      );

  String get facingLabel {
    switch (facing) {
      case facingFront:
        return '전면';
      case facingBack:
        return '후면';
      case facingExternal:
        return '외장';
      default:
        return '방향 불명';
    }
  }

  @override
  String toString() => '$id ($facingLabel, 플래시 ${hasFlash ? '있음' : '없음'})';
}

/// 플래시를 켤 카메라를 고른다. 이 앱의 유일한 선택 정책이다.
///
/// 순수 함수로 두는 이유가 있다. 문제가 되는 기기(카메라 0번이 플래시 카메라가
/// 아닌 기기)를 구하지 않고도, 그 기기의 카메라 목록을 만들어 테스트할 수 있다.
/// 예전에는 이 판단이 플러그인의 Kotlin 안에 `cameraIdList[0]` 으로 박혀 있어
/// 테스트할 방법이 없었다.
///
/// 플래시가 있는 카메라 중 후면을 우선한다. 전면에도 플래시가 있는 기기가
/// 있지만 손전등으로 기대되는 것은 후면이다. 후면이 없으면 플래시가 있는 첫
/// 번째를 쓰고, 플래시가 있는 카메라가 하나도 없으면 null 을 준다.
///
/// [forceCameraWithoutFlash] 는 진단용이다. 플래시 없는 카메라를 일부러 골라
/// "플래시를 못 켜는 기기" 를 손에 있는 기기에서 재현한다.
TorchCamera? selectTorchCamera(
  List<TorchCamera> cameras, {
  bool forceCameraWithoutFlash = false,
}) {
  if (forceCameraWithoutFlash) {
    for (final camera in cameras) {
      if (!camera.hasFlash) {
        return camera;
      }
    }
    return null;
  }

  TorchCamera? firstWithFlash;
  for (final camera in cameras) {
    if (!camera.hasFlash) {
      continue;
    }
    if (camera.isBack) {
      return camera;
    }
    firstWithFlash ??= camera;
  }
  return firstWithFlash;
}

/// 마지막 조회·선택 결과. 진단 표시가 켜져 있을 때 화면에 그린다.
@immutable
class TorchStatus {
  const TorchStatus({
    this.cameras = const [],
    this.chosen,
    this.error,
  });

  final List<TorchCamera> cameras;
  final TorchCamera? chosen;
  final String? error;

  String describe() => [
        '카메라 ${cameras.length}개',
        for (final camera in cameras) '  - $camera',
        '선택: ${chosen ?? '없음'}',
        if (kForceTorchCameraWithoutFlash) '강제 모드: 플래시 없는 카메라 선택 중',
        if (error != null) '오류: $error',
      ].join('\n');
}

/// 플래시를 쓸 수 없어 화면 조명으로 대체해야 하는가.
///
/// 규칙 자체는 한 줄이지만 이름을 붙여 둔다. 플래시가 없는 기기에서 앱이
/// 무엇을 하는지가 이 한 줄에 달려 있고, 테스트로 고정해 둘 만하다.
bool shouldUseScreenLight(TorchCamera? chosen) => chosen == null;

/// 진단 표시가 읽는 값.
TorchStatus torchStatus = const TorchStatus();

bool _usesScreenLight = false;

/// 이 기기가 플래시 대신 화면 조명을 쓰는지.
///
/// 화면이 흰색이어야 하는지, 안내 문구를 띄워야 하는지를 위젯이 이 값으로
/// 판단한다. 카메라 조회가 끝나야 정해지므로 페이지 진입 직후에는 false 다.
bool get usesScreenLight => _usesScreenLight;

TorchCamera? _chosen;

/// 카메라를 한 번 조회해 쓸 카메라를 정한다.
///
/// 성공했을 때만 결과를 캐시한다. 실패는 일시적일 수 있으므로 다음 호출에서
/// 다시 시도하게 둔다.
Future<TorchCamera?> _ensureCamera() async {
  if (_chosen != null) {
    return _chosen;
  }

  if (kIsWeb) {
    torchStatus = const TorchStatus(error: '웹에서는 플래시를 쓸 수 없습니다.');
    return null;
  }

  try {
    final raw = await _channel.invokeListMethod<Object?>('listCameras') ?? [];
    final cameras = <TorchCamera>[];
    for (final entry in raw) {
      if (entry is Map) {
        cameras.add(TorchCamera.fromMap(entry.cast<Object?, Object?>()));
      }
    }
    final chosen = selectTorchCamera(
      cameras,
      forceCameraWithoutFlash: kForceTorchCameraWithoutFlash,
    );
    _chosen = chosen;
    _usesScreenLight = shouldUseScreenLight(chosen);
    torchStatus = TorchStatus(
      cameras: cameras,
      chosen: chosen,
      error: chosen == null ? '플래시를 켤 수 있는 카메라를 찾지 못했습니다.' : null,
    );
  } catch (e) {
    torchStatus = TorchStatus(error: '카메라 목록 조회 실패: $e');
  }

  debugPrint('Torch:\n${torchStatus.describe()}');
  return _chosen;
}

/// 플래시를 토글하고 토글 뒤의 상태를 돌려준다.
///
/// 절대 예외를 던지지 않는다. 예전에는 플러그인이 PlatformException 을 그대로
/// 되던졌고, 버튼 핸들러가 그걸 받지 않아 탭이 조용히 죽었다. 실패하면 이유를
/// [torchStatus] 에 남기고 현재 상태를 돌려준다.
Future<bool> toggleTorch() async {
  final camera = await _ensureCamera();
  if (camera == null) {
    // 플래시가 없는 기기다. 아무 일도 일어나지 않게 두지 않고 화면을
    // 조명으로 쓴다. 위젯이 usesScreenLight 를 보고 화면을 하얗게 만든다.
    return setScreenLight(!screenLightOn);
  }

  final target = !await isTorchOn();
  try {
    await _channel.invokeMethod<bool>('setTorch', {
      'cameraId': camera.id,
      'on': target,
    });
    torchStatus = TorchStatus(cameras: torchStatus.cameras, chosen: camera);
    return target;
  } catch (e) {
    torchStatus = TorchStatus(
      cameras: torchStatus.cameras,
      chosen: camera,
      error: '플래시 전환 실패 (카메라 ${camera.id}): $e',
    );
    debugPrint('Torch:\n${torchStatus.describe()}');
    return isTorchOn();
  }
}

/// 플래시가 켜져 있는지. 시스템이 보고하는 실제 상태다.
Future<bool> isTorchOn() async {
  final camera = await _ensureCamera();
  if (camera == null) {
    // 화면 조명으로 대체된 기기에서는 그쪽 상태가 곧 "켜져 있는지" 다.
    return screenLightOn;
  }
  try {
    final on = await _channel.invokeMethod<bool>('isTorchOn', {
      'cameraId': camera.id,
    });
    return on ?? false;
  } catch (e) {
    debugPrint('Torch: 상태 조회 실패: $e');
    return false;
  }
}
