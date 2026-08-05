---
name: samsung-rtl
description: Samsung Remote Test Lab(RTL)으로 실기기에서 이 앱을 확인할 때 쓴다. CI는 초록불인데 실기기에서만 재현되는 문제(스플래시 멈춤, 런처 아이콘, 특정 기기·OS에서만 나는 크래시), 폴더블/워치/태블릿 등 안 갖고 있는 기기에서 확인, APK를 실기기에 설치해 테스트, RTL 예약·크레딧·기기 목록, Remote Debug Bridge(RDB)로 원격 기기를 adb에 붙이기 등이 해당한다. "실기기에서 확인해야 한다", "기기가 없는데 어떻게 재현하지" 같은 맥락에서도 쓴다.
---

# Samsung Remote Test Lab으로 실기기 확인하기

CI가 초록불이어도 실기기에서만 터지는 문제가 있다 — 이 저장소는 실제로 그런 장애를 겪었다
(스플래시 멈춤, 런처 아이콘이 기본 Flutter 로고로 나감). RTL은 삼성 실기기를 원격으로
빌려 쓰는 무료 서비스고, 기기를 안 들고도 그런 문제를 재현할 수 있다.

## 먼저 알아야 할 현실적 제약

**자동화는 안 된다.** 공개 REST API가 없다. 기기 조작은 브라우저 기반 "RTL Web Client"로만
가능하고, adb 연결(RDB)조차 웹 클라이언트 안에서 사람이 "Connect"를 누르고 기기에서
"Allow"를 눌러야 시작된다. 즉 **CI가 자동으로 도는 루프는 만들 수 없다.**

그래서 현실적인 사용 흐름은 이렇다:

1. CI(`build-apk.yml`)가 APK를 만든다 — 아티팩트로 받는다
2. 사람이 RTL에 로그인해 기기를 예약한다
3. Web Client에 **APK를 드래그앤드롭**하거나 Applications 패널에서 설치
4. 화면·로그를 보며 재현 확인

에이전트가 대신 해줄 수 있는 건 1번까지다. 2~4번은 사람이 해야 한다 —
이걸 먼저 분명히 말하고 시작해라. 할 수 있는 것처럼 굴다가 로그인 벽에서 막히면
사용자 시간만 버린다.

## 로그인 없이 되는 것 / 안 되는 것

로그인 **없이** 되는 것 (에이전트가 직접 조회 가능):
- 전체 기기 목록과 **실시간 가용성** — `https://developer.samsung.com/remotetestlab/devices`
  (1400대 이상, `Available` / `Waiting MM:SS`, 모델·OS·One UI·지역 필터)
- 모든 공식 문서 (이 스킬의 `references/`에 이미 담겨 있다)

로그인이 **필요한** 것: 예약, Web Client 실행, 기기 조작 일체.
로그인은 Samsung Account OAuth2 + reCAPTCHA Enterprise다.

> 기기 목록 페이지는 SPA라 `curl`로는 빈 껍데기만 나온다. 실제로 목록을 읽어야 하면
> 헤드리스 Chromium으로 렌더링해야 한다. 이 환경의 프록시는 Chromium의 TLS 1.3 핸드셰이크를
> RST로 끊으므로 `--ssl-version-max=tls1.2`가 필요하고, Playwright의 `launch()`는 이 플래그를
> 무시하니 Chromium을 직접 띄운 뒤 `connectOverCDP`로 붙여야 한다.

## 자격증명에 대한 경고

사용자가 먼저 제안하기 전에는 삼성 계정 자격증명을 요구하지 마라. 그리고 자격증명 얘기가
나오면 **먼저 이 점을 알려라**: 이 클라우드 환경의 환경변수는 같은 환경을 쓰는 누구나 읽을 수
있고 전용 비밀 저장소가 없다. 삼성 계정은 보통 Play Console 등 다른 것과 묶여 있으므로
여기에 넣는 건 권하지 않는다.

## 크레딧과 예약

- 하루 **20크레딧** 자동 지급, **1크레딧 = 15분**
- 최소 예약 30분(2크레딧), 하루 최대 10시간(40크레딧)
- 무료 (Samsung Developer 회원)
- 예약 시간을 남기고 끝내면 미사용분은 되돌려받는다

## 이 저장소에서 특히 볼 것

스플래시/아이콘 문제를 확인할 때:
- **런처 아이콘**은 `android/app/src/main/res/mipmap-*/ic_launcher.png`가 커밋된 것이 그대로
  나간다. RTL 홈 화면에서 아이콘이 Flutter 기본 로고면 mipmap 재생성이 안 된 것이다.
- **스플래시**는 `flutter_native_splash.yaml` 설정이지만 누가 생성기를 돌려야만 반영된다.
- **edge-to-edge**(targetSdk 35+)라 상단 앱바와 하단 광고 배너가 시스템 UI에 가리는지
  실기기에서 봐야 한다. Device View의 회전·폴딩으로 여러 상태를 확인할 수 있다.

기억할 제약: RTL 기기에는 **SIM이 없다**(통화/문자 테스트 불가). 주변기기 미지원.
device admin 권한을 요구하는 앱은 설치 불가.

## 레퍼런스

`references/`에 공식 문서 전문이 들어 있다(이미지는 저장소 용량 때문에 뺐고, 각 Figure의
캡션과 원본 URL은 `## Figures` 절에 남겨뒀다).

- `remotetestlab-doc-tests-on-devices.md` — **가장 실용적**. APK 설치, File Browser,
  Clipboard, Automated Test, Remote Debug Bridge, Audio Out, Reset Wi-Fi
- `remotetestlab-doc-device-view.md` — 화면 조작: 터치/S Pen, 회전, 폴딩(Flex Mode), 화면 품질, 로그
- `remotetestlab-doc-get-started-with-web-client.md` — 예약부터 세션 시작까지
- `remotetestlab-doc-about-remote-test-lab.md` — 크레딧 정책, 제약사항
- `remotetestlab-docs-2-faq.md` — 크레딧, 국가코드, Wi-Fi 문제
- `remotetestlab-doc-sdb-guide.md` — TV/Tizen용 SDB (이 앱에는 해당 없음)
- `tutorials/` — RDB로 Android Studio에 adb 연결하는 글이 가장 쓸모 있다

Automated Test 기능은 문서상 현재 "temporarily unavailable"이다 — 실제 가용성은 확인되지 않았다.
