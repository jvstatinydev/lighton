#!/usr/bin/env bash
#
# 홈 화면 위젯을 에뮬레이터에서 확인한다. emulator-capture.sh 가 앱 캡처를 마친
# 뒤 source 로 불러 쓴다. $PACKAGE, $OUT 을 물려받는다.
#
# 세 단계다.
#
#  1. 잠긴 리시버(확정적). 위젯 탭이 보내는 것과 같은 브로드캐스트를 adb 로
#     보낸다. "광고 제거" 를 안 샀으니 아무 일도 없어야 한다.
#  2. 풀린 리시버(확정적, root 가 되는 이미지에서만). google_apis 이미지는
#     `adb root` 가 되므로 Dart 가 저장하는 것과 같은 키를 shared_preferences
#     파일에 직접 써서 구매한 상태를 만든다. 그 뒤 같은 브로드캐스트로
#     TorchService 가 뜨고 토치가 켜지는지, 한 번 더 보내 꺼지고 서비스가
#     스스로 멈추는지 본다. 위젯을 놓지 않아도 되고 런처와 무관하다.
#     여기서 실패하면 잡이 빨간불이다.
#  3. 런처(최선 노력). 실제 런처의 위젯 목록에서 "Flashlight (Large)" 를 찾아
#     홈 화면에 끌어다 놓고, 스크린샷을 찍고, 눌러 본다. UI 자동화라 런처
#     버전에 따라 깨질 수 있어서 실패해도 경고만 남긴다. 성공하면
#     06-widget-placed.png / 07-widget-tapped.png 가 실제 그림이다.
#
# 앱은 콜드 스타트마다 Play 에 물어 구매 판정을 갱신하는데, Play 에 못 물어본
# 경우(에뮬레이터가 그렇다) 이전 판정을 유지하므로(lib/flutter_flow/billing_util.dart)
# 2 단계에서 써 넣은 값은 앱이 지우지 않는다.

WIDGET_FAILED=0
WIDGET_UNLOCKED=0

# 부모(emulator-capture.sh)는 set -euo pipefail 이다. 여기서는 adb 가 한 번
# 삐끗하는 것(root 전환 직후 잠깐 offline, grep 무결과 등)으로 잡 전체가 죽지
# 않게 -e 를 잠시 푼다. 실패는 WIDGET_FAILED 로 모아 마지막에 판정한다.
# 실제로 2/3 단계에서 명령 하나가 1 을 돌려주자 로그 한 줄 없이 잡이 끝났다.
set +e

widget_log() {
  echo "$*" | tee -a "$OUT/widget-log.txt"
}

# 토치 서비스가 *포그라운드로* 떠 있는지. 0 이면 안 떠 있는 것이다.
#
# ServiceRecord 가 있다는 것만으로는 부족하다. 시작이 거부된 서비스도 레코드는
# 남아서(startForegroundCount=0, DENIED) 이름만 세면 떠 있다고 잘못 읽는다.
torch_service_running() {
  adb shell dumpsys activity services "$PACKAGE" 2>/dev/null \
    | grep -A60 "ServiceRecord.*TorchService" | grep -c "isForeground=true"
}

# 위젯 탭과 같은 브로드캐스트.
#
# 실제 위젯 탭은 런처가 보내는 PendingIntent 라서 앱이 잠시 백그라운드 시작
# 허용 목록에 오르고, 그 덕에 포그라운드 서비스를 띄울 수 있다. adb 의
# am broadcast 에는 그 특권이 없어서 그냥 보내면 ForegroundServiceStart
# NotAllowedException 이 난다(실제로 났다: uidState RCVR, DENIED). 런처가 주는
# 것과 같은 임시 허용을 deviceidle 로 직접 준다. root 가 아니어도 된다.
widget_toggle() {
  adb shell cmd deviceidle tempwhitelist -d 20000 "$PACKAGE" >/dev/null 2>&1
  adb shell am broadcast -a com.mycompany.lightonflashlight.action.WIDGET_TOGGLE \
    -n "$PACKAGE/.TorchWidget4x4" | tr -d '\r' | tee -a "$OUT/widget-log.txt"
}

# adb 가 다시 응답할 때까지 기다린다(root 전환 뒤 adbd 가 재시작된다).
wait_for_adb() {
  local i
  for i in $(seq 1 20); do
    if adb shell true >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  return 1
}

echo "::group::Widget 1/3: receiver while locked"
adb shell input keyevent KEYCODE_HOME
sleep 2
widget_toggle
sleep 3
if [ "$(torch_service_running)" != "0" ]; then
  widget_log "::error::잠긴 상태의 위젯 토글이 토치 서비스를 띄웠다"
  WIDGET_FAILED=1
else
  widget_log "1/3 잠긴 상태: 토글이 무시됐다 (정상)"
fi
echo "::endgroup::"

echo "::group::Widget 2/3: receiver while unlocked (adb root)"
PREFS_DIR="/data/data/$PACKAGE/shared_prefs"
PREFS="$PREFS_DIR/FlutterSharedPreferences.xml"
ROOT_OK=0
adb root
adb wait-for-device
if wait_for_adb && [ "$(adb shell id -u | tr -d '\r')" = "0" ]; then
  ROOT_OK=1
fi
if [ "$ROOT_OK" = "1" ]; then
  # 앱 데이터 디렉터리의 소유자가 곧 앱 uid 다. dumpsys package 의 userId=
  # 줄을 긁는 것보다 확실하다(그 방법은 API 36 에서 빈 값을 줬고, chown 을
  # 건너뛰어 root 소유 파일이 남는 바람에 앱이 구매 캐시를 읽지 못했다).
  APP_UID="$(adb shell stat -c %u "/data/data/$PACKAGE" | tr -d '\r')"
  widget_log "2/3 adb root 됨, 앱 uid=${APP_UID:-?}"
  # 앱 프로세스가 파일을 캐시하고 있으므로 세운 뒤에 쓴다.
  adb shell am force-stop "$PACKAGE"
  sleep 2
  # shared_preferences 플러그인의 파일과 키 형식(WidgetPrefs.kt 참고). 다른 키는
  # 이 검증에 필요 없으므로 통째로 새로 쓴다.
  adb shell "mkdir -p '$PREFS_DIR'"
  adb shell "printf '%s\n' \"<?xml version='1.0' encoding='utf-8' standalone='yes' ?>\" '<map>' '    <boolean name=\"flutter.__ads_removed__\" value=\"true\" />' '</map>' > '$PREFS'"
  if [ -n "$APP_UID" ]; then
    adb shell "chown $APP_UID:$APP_UID '$PREFS_DIR' '$PREFS'"
  fi
  adb shell "chmod 700 '$PREFS_DIR'; chmod 660 '$PREFS'; restorecon -R '$PREFS_DIR'"
  adb shell ls -lZ "$PREFS_DIR" | tr -d '\r' | tee -a "$OUT/widget-log.txt"
  adb shell cat "$PREFS" | tr -d '\r' >"$OUT/widget-prefs.xml"
  if grep -q '__ads_removed__' "$OUT/widget-prefs.xml"; then
    WIDGET_UNLOCKED=1
    widget_log "2/3 구매 캐시를 써 넣었다"

    # 켜기. 앱이 세워져 있으니 리시버가 프로세스를 새로 띄우는, 실제와 같은 경로다.
    widget_toggle
    sleep 4
    if [ "$(torch_service_running)" != "0" ]; then
      widget_log "2/3 풀린 상태: 토글 -> TorchService 가 떴다 (정상)"
    else
      widget_log "::error::풀린 상태의 위젯 토글이 토치 서비스를 띄우지 못했다"
      WIDGET_FAILED=1
    fi
    adb shell dumpsys activity services "$PACKAGE" | tr -d '\r' >"$OUT/widget-service-on.txt"

    # 끄기. 서비스가 콜백으로 꺼진 것을 보고 스스로 멈춰야 한다.
    widget_toggle
    sleep 4
    if [ "$(torch_service_running)" = "0" ]; then
      widget_log "2/3 풀린 상태: 다시 토글 -> 서비스가 멈췄다 (정상)"
    else
      widget_log "::error::토치를 껐는데 TorchService 가 남아 있다"
      WIDGET_FAILED=1
    fi
  else
    widget_log "::warning::구매 캐시를 쓰지 못했다. 2/3 단계를 건너뛴다."
  fi
else
  widget_log "::warning::adb root 가 안 되는 이미지라 2/3 단계(풀린 위젯)를 건너뛴다."
fi
echo "::endgroup::"

echo "::group::Widget 3/3: launcher (drag the large widget onto the home screen)"
# uiautomator 덤프에서 속성이 일치하는 첫 노드의 중심 좌표 "x y". 없으면 빈 문자열.
node_center() {
  local attr="$1" value="$2"
  adb exec-out uiautomator dump /dev/tty 2>/dev/null \
    | tr -d '\r' \
    | grep -o "<node[^>]*$attr=\"$value\"[^>]*>" \
    | head -1 \
    | grep -o 'bounds="\[[0-9]*,[0-9]*\]\[[0-9]*,[0-9]*\]"' \
    | sed 's/bounds="\[\([0-9]*\),\([0-9]*\)\]\[\([0-9]*\),\([0-9]*\)\]"/\1 \2 \3 \4/' \
    | awk '{ printf "%d %d", ($1+$3)/2, ($2+$4)/2 }'
}

place_widget() {
  local size center wx wy hx hy
  size="$(adb shell wm size | tail -1 | tr -d '\r' | sed 's/.*: //')"
  hx=$(( ${size%x*} / 2 ))
  hy=$(( ${size#*x} / 2 ))

  adb shell input keyevent KEYCODE_HOME || true
  sleep 2
  # 빈 곳을 길게 눌러 홈 화면 메뉴를 연다.
  adb shell input swipe "$hx" "$hy" "$hx" "$hy" 1500 || true
  sleep 2
  center="$(node_center text Widgets)"
  if [ -z "$center" ]; then
    widget_log "런처 메뉴에서 'Widgets' 를 찾지 못했다"
    adb exec-out uiautomator dump /dev/tty 2>/dev/null | tr -d '\r' >"$OUT/widget-dump-home-menu.xml" || true
    return 1
  fi
  # shellcheck disable=SC2086
  adb shell input tap $center
  sleep 3

  # 위젯 목록의 검색창에 앱 이름을 넣는다.
  center="$(node_center resource-id "com.google.android.apps.nexuslauncher:id/widgets_search_bar_edit_text")"
  if [ -z "$center" ]; then
    center="$(node_center text "Search")"
  fi
  if [ -n "$center" ]; then
    # shellcheck disable=SC2086
    adb shell input tap $center
    sleep 1
    adb shell input text "Light" || true
    sleep 3
  else
    widget_log "위젯 목록의 검색창을 찾지 못했다 -- 스크롤 없이 시도한다"
  fi
  # 키보드가 올라와 있으면 내린다. 키보드가 떠 있을 때 BACK 은 키보드만 닫는다.
  if adb shell dumpsys input_method | grep -q "mInputShown=true"; then
    adb shell input keyevent KEYCODE_BACK
    sleep 1
  fi
  adb exec-out screencap -p >"$OUT/06a-widget-picker.png"
  adb exec-out uiautomator dump /dev/tty 2>/dev/null | tr -d '\r' >"$OUT/widget-dump-picker.xml"

  # 검색 결과는 앱 한 줄로 접혀 있다("Light On - Flashlight" 아래에 위젯 이름이
  # 쉼표로 나열된다). 줄을 눌러 펼쳐야 위젯 미리보기가 나온다.
  center="$(node_center text "Light On - Flashlight")"
  if [ -n "$center" ]; then
    # shellcheck disable=SC2086
    adb shell input tap $center
    sleep 3
  else
    widget_log "위젯 목록에서 앱 줄을 찾지 못했다"
  fi
  adb exec-out screencap -p >"$OUT/06b-widget-picker-expanded.png"
  adb exec-out uiautomator dump /dev/tty 2>/dev/null | tr -d '\r' >"$OUT/widget-dump-picker-expanded.xml"

  # 우리 앱의 4×4 위젯. 펼친 목록은 세로로 길어서 Large 는 스크롤해야 보인다.
  # 런처는 미리보기 노드(WidgetCell$2)의 content-desc 에 위젯 라벨을 그대로
  # 쓴다. 몇 번 스크롤해도 안 보이면 눈에 띄는 다른 크기로 대신한다.
  local i label
  center=""
  for i in 1 2 3 4; do
    center="$(node_center content-desc "Flashlight (Large)")"
    [ -n "$center" ] && { label="Large"; break; }
    adb shell input swipe "$hx" $(( hy + 600 )) "$hx" $(( hy - 600 )) 400
    sleep 2
  done
  if [ -z "$center" ]; then
    for label in Wide Medium Small; do
      center="$(node_center content-desc "Flashlight ($label)")"
      [ -n "$center" ] && break
    done
  fi
  if [ -z "$center" ]; then
    widget_log "위젯 목록에서 위젯 미리보기를 찾지 못했다 (widget-dump-picker-expanded.xml 참고)"
    adb shell input keyevent KEYCODE_BACK
    return 1
  fi
  widget_log "3/3 끌어다 놓을 위젯: Flashlight ($label) @ $center"
  adb exec-out uiautomator dump /dev/tty 2>/dev/null | tr -d '\r' >"$OUT/widget-dump-picker-scrolled.xml"
  wx="${center% *}"
  wy="${center#* }"
  # 길게 눌러 집어서 홈 화면 가운데에 놓는다. draganddrop 이 없는 버전은 swipe 로.
  adb shell input draganddrop "$wx" "$wy" "$hx" "$hy" 1500 2>/dev/null \
    || adb shell input swipe "$wx" "$wy" "$hx" "$hy" 1500 || true
  sleep 4
  # 놓은 직후 뜨는 크기 조절 틀을 없앤다.
  adb shell input keyevent KEYCODE_BACK || true
  sleep 1
  return 0
}

if place_widget; then
  adb exec-out screencap -p >"$OUT/06-widget-placed.png"
  widget_log "3/3 위젯을 놓았다: 06-widget-placed.png"

  center="$(node_center resource-id "$PACKAGE:id/widget_root")"
  if [ -n "$center" ]; then
    # shellcheck disable=SC2086
    adb shell input tap $center
    sleep 5
    adb exec-out screencap -p >"$OUT/07-widget-tapped.png"
    focus="$(adb shell dumpsys window 2>/dev/null | grep -m1 'mCurrentFocus=' | tr -d '\r')"
    widget_log "3/3 위젯을 눌렀다: 07-widget-tapped.png, 포커스: $focus"
    if [ "$WIDGET_UNLOCKED" = "1" ]; then
      # 풀린 위젯: 앱을 띄우지 않고 켜져야 한다.
      if [ "$(torch_service_running)" != "0" ]; then
        widget_log "3/3 풀린 위젯 탭 -> 켜짐, 서비스 떠 있음 (정상)"
      else
        widget_log "::warning::풀린 위젯을 눌렀는데 토치 서비스가 뜨지 않았다"
      fi
      # 다시 눌러 끈다.
      # shellcheck disable=SC2086
      adb shell input tap $center
      sleep 4
      adb exec-out screencap -p >"$OUT/08-widget-tapped-again.png"
      if [ "$(torch_service_running)" = "0" ]; then
        widget_log "3/3 다시 탭 -> 꺼짐, 서비스 멈춤 (정상)"
      else
        widget_log "::warning::다시 눌렀는데 토치 서비스가 남아 있다"
      fi
    else
      # 잠긴 위젯: 앱이 결제 시트를 연 채로 떠야 한다.
      case "$focus" in
        *"$PACKAGE"*) widget_log "3/3 잠긴 위젯 탭 -> 앱이 떴다 (정상)" ;;
        *) widget_log "::warning::잠긴 위젯을 눌렀는데 앱이 앞에 오지 않았다" ;;
      esac
    fi
  else
    widget_log "::warning::홈 화면에서 위젯 루트(widget_root)를 찾지 못해 누르지 못했다"
    adb exec-out uiautomator dump /dev/tty 2>/dev/null | tr -d '\r' >"$OUT/widget-dump-home.xml" || true
  fi
else
  widget_log "::warning::런처 UI 자동화로 위젯을 놓지 못했다. 리시버 단계 결과만 유효하다."
  adb exec-out screencap -p >"$OUT/06-widget-placement-failed.png" || true
fi
echo "::endgroup::"

echo "::group::Widget: logs"
adb logcat -d -v time -s LightOnTorch:V >"$OUT/logcat-widget.txt" || true
cat "$OUT/logcat-widget.txt" || true
echo "::endgroup::"

# 부모의 set -e 를 되돌린다.
set -e
