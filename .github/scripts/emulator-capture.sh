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

# 화면을 돌린다.
#
# 이 부분은 두 번 틀렸다. 처음에는 `settings put system user_rotation` 만 썼는데
# API 36 에서 값은 들어가고 디스플레이는 ROTATION_0 그대로였다. 그래서 Android
# 12 부터 있는 `cmd window set-user-rotation` 을 앞에 세웠는데, 그 명령은 API 36
# 에서 *종료 코드 0 을 주면서 아무것도 하지 않았다*. `||` 로 엮은 폴백은 앞이
# 성공했다고 보고 건너뛰었고, 결과는 처음과 똑같았다 -- "가로" 라는 이름이 붙은
# 세로 스크린샷. 경고는 남았지만 잡은 초록이라 아무도 보지 않았다.
#
# 교훈은 하나다. 회전은 종료 코드로 판정할 수 없다. 실제 방향을 다시 읽어서
# 확인해야 하고, 확인될 때까지 다음 방법으로 넘어가야 한다.
#
# 방법 네 가지를 순서대로 시도한다. `user-rotation` 이 현재 이름이고
# `set-user-rotation` 은 예전 이름이라 안드로이드 버전에 따라 하나만 존재한다.
# 셋 다 게스트 안에서 도는 명령이라 안드로이드 버전을 타므로, 마지막에는
# 버전과 무관한 에뮬레이터 콘솔(`adb emu rotate`)까지 내려간다.
ROTATE_FAILED=0

# 디스플레이가 실제로 어느 방향인지 읽는다. 못 읽으면 빈 문자열.
actual_rotation() {
  adb shell dumpsys window displays 2>/dev/null \
    | grep -o 'mDisplayRotation=ROTATION_[0-9]*' | head -1 | sed 's/.*ROTATION_//'
}

# 방향이 요청대로 바뀌기를 최대 12초 기다린다. 바뀌면 0, 아니면 1.
wait_for_rotation() {
  local want="$1" i
  for i in $(seq 1 12); do
    sleep 1
    [ "$(actual_rotation)" = "$want" ] && return 0
  done
  return 1
}

# 마지막 수단. 게스트가 아니라 에뮬레이터 콘솔에 시키는 것이라 안드로이드
# 버전과 무관하다. 다만 절대 각도를 못 주고 90도씩 돌기만 하므로, 원하는
# 방향이 될 때까지 최대 세 번 돌린다.
rotate_via_emu() {
  local want="$1" i
  for i in 1 2 3; do
    adb emu rotate >/dev/null 2>&1 || return 1
    if wait_for_rotation "$want"; then
      return 0
    fi
  done
  return 1
}

rotate() {
  local rotation="$1" method
  if [ "$(actual_rotation)" = "$rotation" ]; then
    return 0
  fi
  for method in \
    "cmd window user-rotation lock $rotation" \
    "cmd window set-user-rotation lock -d 0 $rotation" \
    "settings put system user_rotation $rotation"
  do
    # shellcheck disable=SC2086
    adb shell $method >/dev/null 2>&1 || true
    if wait_for_rotation "$rotation"; then
      echo "rotation=$rotation: '$method' 로 적용됨"
      # 방향이 바뀐 뒤 앱이 새 크기로 다시 그릴 시간. 광고 배너는 다시
      # 요청되지 않지만 레이아웃은 다시 잡힌다.
      sleep 5
      return 0
    fi
    echo "rotation=$rotation: '$method' 는 듣지 않았다"
  done
  if rotate_via_emu "$rotation"; then
    echo "rotation=$rotation: 'adb emu rotate' 로 적용됨"
    sleep 5
    return 0
  fi
  echo "rotation=$rotation: 'adb emu rotate' 도 듣지 않았다"
  return 1
}

capture() {
  local rotation="$1" name="$2"
  local got
  if ! rotate "$rotation"; then
    ROTATE_FAILED=1
  fi
  got="$(actual_rotation)"
  adb exec-out screencap -p >"$OUT/${name}.png"
  echo "captured $OUT/${name}.png (요청 rotation=$rotation, 실제 ROTATION_${got:-?})"
  echo "${name} requested=${rotation} actual=${got:-unknown}" >>"$OUT/rotation-log.txt"
  if [ -n "$got" ] && [ "$got" != "$rotation" ]; then
    # 경고가 아니라 오류다. 방향이 안 바뀐 스크린샷은 틀린 답을 자신 있게
    # 내놓는다 -- 가로 배치를 확인했다고 착각하게 만든다. 잡을 끝에서
    # 떨어뜨려서, 결과를 읽기 전에 알 수 있게 한다.
    echo "::error::${name}: 회전이 요청대로 적용되지 않았습니다 (요청 $rotation, 실제 $got)"
    ROTATE_FAILED=1
  fi
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
# 탭 전에 세로로 되돌린다. 좌표를 세로 기준으로 계산하기 때문이다.
rotate 0 || ROTATE_FAILED=1

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

# 시스템 바가 실제로 몇 dp 를 먹었는지. edge-to-edge 에서는 이 값이 곧
# SafeArea 가 비켜줘야 하는 폭이고, 앱이 lib/flutter_flow/edge_to_edge_util.dart
# 에서 방향이 바뀔 때마다 찍는다. 스크린샷을 눈으로 재지 않고 숫자로 볼 수 있다.
grep -A6 "System insets:" "$OUT/logcat-flutter.txt" >"$OUT/insets.txt" || true
echo "::endgroup::"

echo "=== flutter log ==="
cat "$OUT/logcat-flutter.txt" || true

echo "=== system insets ==="
cat "$OUT/insets.txt" || true

# 회전이 한 번이라도 요청대로 안 됐으면 잡을 떨어뜨린다. 아티팩트 업로드는
# `if: always()` 라 그대로 올라가므로, 찍힌 것은 다 보면서 "가로를 봤다" 는
# 착각만 막는다.
if [ "$ROTATE_FAILED" -ne 0 ]; then
  echo "::error::요청한 방향으로 돌지 않은 캡처가 있습니다. rotation-log.txt 를 보세요."
  exit 1
fi
