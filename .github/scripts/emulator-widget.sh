#!/usr/bin/env bash
#
# 홈 화면 위젯을 에뮬레이터에서 확인한다. emulator-capture.sh 가 앱 캡처를 마친
# 뒤 source 로 불러 쓴다. $PACKAGE, $OUT 을 물려받는다.
#
# 네 단계다. 잠긴 상태를 먼저 보고, 그 다음에 구매한 상태를 만든다.
#
#  1. 잠긴 리시버(확정적). 위젯 탭이 보내는 것과 같은 브로드캐스트를 adb 로
#     보낸다. "광고 제거" 를 안 샀으니 아무 일도 없어야 한다.
#  2. 런처에 놓기(최선 노력). 실제 런처의 위젯 목록에서 "Flashlight (Large)" 를
#     찾아 홈 화면에 끌어다 놓고 잠긴 모습을 찍는다. 잠긴 위젯을 누르면 앱이
#     결제 시트를 연 채로 떠야 한다. UI 자동화라 런처 버전에 따라 깨질 수
#     있어서 실패해도 경고만 남긴다.
#  3. 풀린 리시버(확정적, root 가 되는 이미지에서만). google_apis 이미지는
#     `adb root` 가 되므로 Dart 가 저장하는 것과 같은 키를 shared_preferences
#     파일에 직접 써서 구매한 상태를 만든다. 그 뒤 같은 브로드캐스트로
#     TorchService 가 뜨고 토치가 켜지는지, 한 번 더 보내 꺼지고 서비스가
#     스스로 멈추는지 본다. 여기서 실패하면 잡이 빨간불이다.
#  4. 풀린 위젯 누르기(최선 노력). 2 에서 놓은 위젯이 풀린 모습으로 다시
#     그려졌는지 찍고, 눌러서 켜지고 다시 눌러 꺼지는지 본다.
#
# 앱은 콜드 스타트마다 Play 에 물어 구매 판정을 갱신하는데, Play 에 못 물어본
# 경우(에뮬레이터가 그렇다) 이전 판정을 유지하므로(lib/flutter_flow/billing_util.dart)
# 3 단계에서 써 넣은 값은 앱이 지우지 않는다.

WIDGET_FAILED=0
WIDGET_UNLOCKED=0
WIDGET_PLACED=0
WIDGET_CENTER=""

# 부모(emulator-capture.sh)는 set -euo pipefail 이다. 여기서는 adb 가 한 번
# 삐끗하는 것(root 전환 직후 잠깐 offline, grep 무결과 등)으로 잡 전체가 죽지
# 않게 -e 를 잠시 푼다. 실패는 WIDGET_FAILED 로 모아 마지막에 판정한다.
# 실제로 명령 하나가 1 을 돌려주자 로그 한 줄 없이 잡이 끝난 적이 있다.
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

# 지금 화면 맨 앞에 있는 창.
widget_focus() {
  adb shell dumpsys window 2>/dev/null | grep -m1 'mCurrentFocus=' | tr -d '\r' | sed 's/^ *//'
}

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

echo "::group::Widget 1/4: receiver while locked"
adb shell input keyevent KEYCODE_HOME
sleep 2
widget_toggle
sleep 3
if [ "$(torch_service_running)" != "0" ]; then
  widget_log "::error::잠긴 상태의 위젯 토글이 토치 서비스를 띄웠다"
  WIDGET_FAILED=1
else
  widget_log "1/4 잠긴 상태: 토글이 무시됐다 (정상)"
fi
echo "::endgroup::"

echo "::group::Widget 2/4: launcher (drag the large widget onto the home screen, locked)"
place_widget() {
  local size center wx wy hx hy i label
  size="$(adb shell wm size | tail -1 | tr -d '\r' | sed 's/.*: //')"
  hx=$(( ${size%x*} / 2 ))
  hy=$(( ${size#*x} / 2 ))

  adb shell input keyevent KEYCODE_HOME
  sleep 2
  # 빈 곳을 길게 눌러 홈 화면 메뉴를 연다.
  adb shell input swipe "$hx" "$hy" "$hx" "$hy" 1500
  sleep 2
  center="$(node_center text Widgets)"
  if [ -z "$center" ]; then
    widget_log "런처 메뉴에서 'Widgets' 를 찾지 못했다"
    adb exec-out uiautomator dump /dev/tty 2>/dev/null | tr -d '\r' >"$OUT/widget-dump-home-menu.xml"
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
    adb shell input text "Light"
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
  widget_log "2/4 끌어다 놓을 위젯: Flashlight ($label) @ $center"
  wx="${center% *}"
  wy="${center#* }"
  # 길게 눌러 집어서 홈 화면 가운데에 놓는다. draganddrop 이 없는 버전은 swipe 로.
  adb shell input draganddrop "$wx" "$wy" "$hx" "$hy" 1500 2>/dev/null \
    || adb shell input swipe "$wx" "$wy" "$hx" "$hy" 1500
  sleep 4
  # 놓은 직후 뜨는 크기 조절 틀을 없앤다.
  adb shell input keyevent KEYCODE_BACK
  sleep 1
  return 0
}

if place_widget; then
  WIDGET_CENTER="$(node_center resource-id "$PACKAGE:id/widget_root")"
  if [ -n "$WIDGET_CENTER" ]; then
    WIDGET_PLACED=1
    adb exec-out screencap -p >"$OUT/06-widget-placed-locked.png"
    widget_log "2/4 위젯을 놓았다(잠김): 06-widget-placed-locked.png"

    # 잠긴 위젯을 누르면 앱이 결제 시트를 연 채로 떠야 한다.
    # shellcheck disable=SC2086
    adb shell input tap $WIDGET_CENTER
    sleep 6
    adb exec-out screencap -p >"$OUT/07-locked-widget-tapped.png"
    focus="$(widget_focus)"
    case "$focus" in
      *"$PACKAGE"*) widget_log "2/4 잠긴 위젯 탭 -> 앱이 떴다 (정상): 07-locked-widget-tapped.png" ;;
      *) widget_log "::warning::잠긴 위젯을 눌렀는데 앱이 앞에 오지 않았다: $focus" ;;
    esac
    adb shell input keyevent KEYCODE_HOME
    sleep 2
  else
    widget_log "::warning::홈 화면에서 위젯 루트(widget_root)를 찾지 못했다"
    adb exec-out screencap -p >"$OUT/06-widget-placement-failed.png"
    adb exec-out uiautomator dump /dev/tty 2>/dev/null | tr -d '\r' >"$OUT/widget-dump-home.xml"
  fi
else
  widget_log "::warning::런처 UI 자동화로 위젯을 놓지 못했다. 리시버 단계 결과만 유효하다."
  adb exec-out screencap -p >"$OUT/06-widget-placement-failed.png"
fi
echo "::endgroup::"

echo "::group::Widget 3/4: receiver while unlocked (adb root)"
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
  widget_log "3/4 adb root 됨, 앱 uid=${APP_UID:-?}"
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
  adb shell ls -lZ "$PREFS" | tr -d '\r' | tee -a "$OUT/widget-log.txt"
  adb shell cat "$PREFS" | tr -d '\r' >"$OUT/widget-prefs.xml"
  if grep -q '__ads_removed__' "$OUT/widget-prefs.xml"; then
    WIDGET_UNLOCKED=1
    widget_log "3/4 구매 캐시를 써 넣었다"

    # 켜기. 앱이 세워져 있으니 리시버가 프로세스를 새로 띄우는, 실제와 같은 경로다.
    widget_toggle
    sleep 4
    if [ "$(torch_service_running)" != "0" ]; then
      widget_log "3/4 풀린 상태: 토글 -> TorchService 가 떴다 (정상)"
    else
      widget_log "::error::풀린 상태의 위젯 토글이 토치 서비스를 띄우지 못했다"
      WIDGET_FAILED=1
    fi
    adb shell dumpsys activity services "$PACKAGE" | tr -d '\r' >"$OUT/widget-service-on.txt"

    # 끄기. 서비스가 콜백으로 꺼진 것을 보고 스스로 멈춰야 한다.
    widget_toggle
    sleep 4
    if [ "$(torch_service_running)" = "0" ]; then
      widget_log "3/4 풀린 상태: 다시 토글 -> 서비스가 멈췄다 (정상)"
    else
      widget_log "::error::토치를 껐는데 TorchService 가 남아 있다"
      WIDGET_FAILED=1
    fi
  else
    widget_log "::warning::구매 캐시를 쓰지 못했다. 3/4 단계를 건너뛴다."
  fi
else
  widget_log "::warning::adb root 가 안 되는 이미지라 3/4 단계(풀린 위젯)를 건너뛴다."
fi
echo "::endgroup::"

# 4/4 단계를 화면 녹화로도 남긴다. Play Console 의 포그라운드 서비스 선언 폼이
# "기능을 실행하는 단계를 보여 주는 시연 동영상" 링크를 요구하는데, 실기기 없이
# 만들 수 있는 것이 이 녹화다(widget-demo.mp4). screenrecord 는 에뮬레이터
# 인코더에 따라 빈 파일을 남기기도 하므로 screencap 프레임을 따로 모아
# ffmpeg 으로 이어 붙인 widget-demo-frames.mp4 를 함께 만든다.
REC_FLAG="$OUT/.recording"
FRAMES_DIR="$OUT/widget-demo-frames"
start_recording() {
  adb shell rm -f /sdcard/widget-demo.mp4
  adb shell screenrecord --time-limit 90 --bit-rate 4000000 /sdcard/widget-demo.mp4 &
  mkdir -p "$FRAMES_DIR"
  touch "$REC_FLAG"
  (
    i=0
    while [ -f "$REC_FLAG" ]; do
      adb exec-out screencap -p >"$FRAMES_DIR/$(printf '%04d' "$i").png"
      i=$((i + 1))
      sleep 0.5
    done
  ) &
  FRAMES_PID=$!
}
stop_recording() {
  rm -f "$REC_FLAG"
  wait "$FRAMES_PID" 2>/dev/null
  # SIGINT 로 끝내야 mp4 의 moov 가 써진다.
  adb shell pkill -INT screenrecord
  sleep 4
  wait 2>/dev/null
  adb pull /sdcard/widget-demo.mp4 "$OUT/widget-demo.mp4" || true
  local size
  size="$(stat -c %s "$OUT/widget-demo.mp4" 2>/dev/null || echo 0)"
  if [ "$size" -gt 10000 ]; then
    widget_log "4/4 화면 녹화: widget-demo.mp4 (${size} bytes)"
  else
    rm -f "$OUT/widget-demo.mp4"
    widget_log "::warning::screenrecord 가 쓸 만한 파일을 남기지 않았다"
  fi
  local n
  n="$(ls "$FRAMES_DIR" 2>/dev/null | wc -l)"
  if command -v ffmpeg >/dev/null 2>&1 && [ "$n" -gt 1 ]; then
    if ffmpeg -loglevel error -y -framerate 2 -i "$FRAMES_DIR/%04d.png" \
        -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' -c:v libx264 -pix_fmt yuv420p \
        "$OUT/widget-demo-frames.mp4"; then
      widget_log "4/4 프레임 ${n} 장 -> widget-demo-frames.mp4"
      rm -rf "$FRAMES_DIR"
    else
      widget_log "::warning::ffmpeg 이 프레임을 잇지 못했다. 프레임은 $FRAMES_DIR 에 남긴다."
    fi
  else
    widget_log "::warning::ffmpeg 이 없거나 프레임이 ${n} 장뿐이라 프레임 동영상은 만들지 않는다"
  fi
}

echo "::group::Widget 4/4: tap the unlocked widget on the home screen"
if [ "$WIDGET_PLACED" = "1" ] && [ "$WIDGET_UNLOCKED" = "1" ]; then
  adb shell input keyevent KEYCODE_HOME
  sleep 2
  # 3/4 의 토글 브로드캐스트가 위젯을 다시 그렸으므로 이제 풀린 모습이어야 한다.
  adb exec-out screencap -p >"$OUT/08-widget-unlocked.png"
  start_recording
  sleep 3
  # shellcheck disable=SC2086
  adb shell input tap $WIDGET_CENTER
  sleep 5
  adb exec-out screencap -p >"$OUT/09-widget-on.png"
  if [ "$(torch_service_running)" != "0" ]; then
    widget_log "4/4 풀린 위젯 탭 -> 켜짐, 서비스 떠 있음 (정상): 09-widget-on.png"
  else
    widget_log "::warning::풀린 위젯을 눌렀는데 토치 서비스가 뜨지 않았다"
  fi
  # 알림 창을 내려 서비스 알림을 보여 준다. POST_NOTIFICATIONS 를 요청하지 않으므로
  # API 33+ 에서는 비어 있을 수 있다(CLAUDE.md 참고). 그래도 녹화에 "화면을 떠나도
  # 켜져 있다" 는 장면이 들어간다.
  adb shell cmd statusbar expand-notifications
  sleep 3
  adb exec-out screencap -p >"$OUT/09b-widget-on-notifications.png"
  adb shell cmd statusbar collapse
  sleep 2
  # 앱을 열어 앱의 버튼도 켜진 상태로 보이는지 남긴다(위젯과 앱이 같은 모니터를 읽는다).
  adb shell monkey -p "$PACKAGE" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
  sleep 5
  adb exec-out screencap -p >"$OUT/09c-app-while-widget-on.png"
  adb shell input keyevent KEYCODE_HOME
  sleep 3
  # shellcheck disable=SC2086
  adb shell input tap $WIDGET_CENTER
  sleep 4
  adb exec-out screencap -p >"$OUT/10-widget-off.png"
  if [ "$(torch_service_running)" = "0" ]; then
    widget_log "4/4 다시 탭 -> 꺼짐, 서비스 멈춤 (정상): 10-widget-off.png"
  else
    widget_log "::warning::다시 눌렀는데 토치 서비스가 남아 있다"
  fi
  sleep 2
  stop_recording
else
  widget_log "4/4 건너뜀 (위젯 놓기 $WIDGET_PLACED, 구매 캐시 $WIDGET_UNLOCKED)"
fi
echo "::endgroup::"

echo "::group::Widget: logs"
adb logcat -d -v time -s LightOnTorch:V >"$OUT/logcat-widget.txt"
cat "$OUT/logcat-widget.txt"
echo "::endgroup::"

# 부모의 set -e 를 되돌린다.
set -e
