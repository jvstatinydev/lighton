import 'package:flutter_test/flutter_test.dart';
import 'package:light_on_flashlight/flutter_flow/flutter_flow_ad_banner.dart'
    show kShowAdBannerDiagnostics;
import 'package:light_on_flashlight/flutter_flow/torch_util.dart'
    show kForceTorchCameraWithoutFlash, kShowTorchDiagnostics;

/// 출시 빌드에 들어가면 안 되는 상수들.
///
/// 이 레포에는 adb 로 logcat 을 볼 수 없어서(CLAUDE.md 의 `adb` 항목) 진단을
/// 화면에 그리는 상수가 여럿 있다. 조사할 때 켜고 출시 전에 되돌려야 하는데,
/// 되돌리는 것을 잊으면 사용자 화면에 디버그 상자가 뜨거나(광고 배너 진단)
/// 플래시가 아예 안 켜지는(강제 카메라 선택) 빌드가 그대로 나간다.
///
/// 그래서 이 테스트는 Play 로 가는 build-aab.yml 에서만 돌린다.
/// 사이드로드용 build-apk.yml 은 조사용 빌드를 만드는 통로이므로, 거기서
/// 진단을 켠 채 빌드하는 것은 정상이고 막으면 안 된다.
void main() {
  group('출시 빌드에 진단이 켜져 있으면 안 된다', () {
    test('플래시 진단 표시', () {
      expect(kShowTorchDiagnostics, isFalse);
    });

    test('플래시 카메라 강제 선택', () {
      // 켜진 채로 나가면 플래시가 아예 켜지지 않는다.
      expect(kForceTorchCameraWithoutFlash, isFalse);
    });

    test('광고 배너 진단 표시', () {
      // 켜진 채로 나가면 광고가 실패했을 때 검은 상자가 그대로 보인다.
      expect(kShowAdBannerDiagnostics, isFalse);
    });
  });
}
