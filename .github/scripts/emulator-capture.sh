#!/usr/bin/env bash
#
# 에뮬레이터에 APK 를 설치하고 실행한 뒤, 화면과 logcat 을 emulator-out/ 에 남긴다.
# .github/workflows/emulator-check.yml 에서 android-emulator-runner 의 script 로 불린다.
#
# 워크플로 YAML 안에 인라인으로 넣지 않은 이유: adb 호출이 여러 단계라
# YAML 블록 스칼라 안에서 따옴표와 리다이렉션이 얽히면 읽기 어려워진다.

set -euo pipefail

SETTLE_SECONDS="${1:-25}"
PACKAGE="com.mycompany.lightonflashlight"
APK="build/app/outputs/flutter-apk/app-release.apk"
OUT="emulator-out"

mkdir -p "$OUT"

# 화면이 켜져 있고 잠금이 풀린 상태를 보장한다. 에뮬레이터가 부팅 직후
# 잠금화면에 머물면 스크린샷이 전부 잠금화면이 된다.
adb shell input keyevent KEYCODE_WAKEUP || true
adb shell wm dismiss-keyguard || true

# 자동 회전을 끈다. 아래에서 user_rotation 으로 방향을 직접 정하는데,
# 자동 회전이 켜져 있으면 그 값이 무시된다.
adb shell settings put system accelerometer_rotation 0 || true

echo "::group::Install"
adb install -r "$APK"
echo "::endgroup::"

# 앱 자신의 출력만 보기 위해 실행 직전에 버퍼를 비운다.
adb logcat -c || true

echo "::group::Launch"
adb shell monkey -p "$PACKAGE" -c android.intent.category.LAUNCHER 1
echo "::endgroup::"

# 스플래시 → 홈, 광고 배너 요청(UMP 동의 조회는 네트워크를 탄다)까지 끝날 시간을 준다.
echo "Waiting ${SETTLE_SECONDS}s for the app to settle..."
sleep "$SETTLE_SECONDS"

capture() {
  local rotation="$1" name="$2"
  adb shell settings put system user_rotation "$rotation"
  # 회전 후 레이아웃이 다시 잡히기를 기다린다. 배너는 방향에 따라 배치가 달라진다.
  sleep 6
  adb exec-out screencap -p >"$OUT/${name}.png"
  echo "captured $OUT/${name}.png"
}

capture 0 01-portrait
capture 1 02-landscape
capture 0 03-portrait-again

# 홈 화면의 토치 버튼을 눌러본다. 에뮬레이터에는 플래시가 없으므로 이건
# "플래시 없는 기기" 경로를 타고, 앱이 죽지 않는지와 무엇을 보여주는지를 본다.
#
# 좌표는 화면 크기에서 계산한다. 토글은 Align(0.0, 0.0) 으로 가운데에 있으므로
# (lib/pages/home_page/home_page_widget.dart) 화면 중앙을 누르면 닿는다.
# 하드코딩하면 profile 이나 API 레벨을 바꿨을 때 조용히 빗나간다.
echo "::group::Tap center (torch button)"
SIZE="$(adb shell wm size | tail -1 | tr -d '\r' | sed 's/.*: //')"
TAP_X=$(( ${SIZE%x*} / 2 ))
TAP_Y=$(( ${SIZE#*x} / 2 ))
echo "screen=$SIZE tap=($TAP_X,$TAP_Y)"
adb shell input tap "$TAP_X" "$TAP_Y" || true
sleep 5
adb exec-out screencap -p >"$OUT/04-after-tap.png"
echo "::endgroup::"

echo "::group::Collect logs"
# 전체 로그. 네이티브 크래시나 플러그인 경고는 flutter 태그 밖에서 나온다.
adb logcat -d -v time >"$OUT/logcat-full.txt"

# Dart 쪽 print/debugPrint 는 flutter 태그로 나온다. torch_util.dart 의
# `Torch:\n...` 와 admob_util.dart 의 `AdMob readiness:\n...` 가 여기 있다.
adb logcat -d -v time -s flutter:V >"$OUT/logcat-flutter.txt" || true

# 광고와 토치 관련 네이티브 로그만 따로 추려둔다. 전체 로그에서 찾기 번거롭다.
grep -iE "ads|admob|consent|ump|torch|camera|flash" "$OUT/logcat-full.txt" \
  >"$OUT/logcat-relevant.txt" || true

# 앱이 아직 살아 있는지. 비어 있으면 실행 중 죽은 것이다.
adb shell pidof "$PACKAGE" >"$OUT/still-running.txt" || true

adb shell dumpsys window displays | head -40 >"$OUT/display-info.txt" || true
echo "::endgroup::"

echo "=== flutter log ==="
cat "$OUT/logcat-flutter.txt" || true
