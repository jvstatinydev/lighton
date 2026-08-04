---
name: play-release
description: Google Play Developer API v3(androidpublisher)로 이 앱을 출시·조회할 때 쓴다. Play Console에 올리기, 트랙(internal/alpha/beta/production) 변경, 단계적 출시, 출시 이름·릴리스 노트 수정, 번들/버전코드 확인, build-aab.yml·play-status.yml·play-release-name.yml 워크플로 수정이나 디버깅, "Play에 올려줘", "지금 어느 트랙에 뭐가 올라가 있어?", edits API 401/403/409 오류 해결 등이 모두 해당한다. Play Console UI는 로그인 벽 때문에 이 환경에서 열 수 없으므로, Play 관련 작업은 화면을 열려고 하지 말고 이 스킬의 API 경로를 쓴다.
---

# Play Developer API로 출시하기

Play Console 웹 UI는 이 환경에서 못 연다 — 익명 세션은 마케팅 페이지로 리다이렉트된다.
반면 **API는 서비스 계정만 있으면 전부 열려 있다.** 그래서 이 저장소의 Play 관련 작업은
전부 API 경로로 처리한다. 브라우저를 띄우려 시도하지 마라.

## 먼저 알아야 할 것: edit은 트랜잭션이다

Publishing API에서 앱을 바꾸는 모든 작업은 **edit**이라는 트랜잭션 안에서 일어난다.

```
edits.insert   → editId 발급
   ... 변경 (bundles.upload, tracks.update, listings.patch ...)
edits.validate → (선택) 검증만
edits.commit   → 실제 반영
edits.delete   → 버림
```

commit 전에는 **아무것도 Play에 반영되지 않는다.** 이 성질이 중요한 이유:

- 조회조차 edit을 하나 열어야 한다(`edits.tracks.list` 등이 editId를 요구). 그래서
  "읽기 전용"이라는 건 **commit을 안 하고 delete로 버린다**는 규율로만 성립한다.
  OAuth 스코프는 `https://www.googleapis.com/auth/androidpublisher` **하나뿐**이고
  읽기 전용 스코프가 따로 없다. 조회 스크립트를 쓸 때 실수로 commit을 넣지 않도록 주의.
- edit을 열어두고 방치하면 다음 edit과 충돌한다. 실패 경로에서도 `edits.delete`가
  돌도록 짜라(`play-status.yml`이 이 패턴을 쓴다).

## 이 저장소의 워크플로가 타는 경로

| 워크플로 | 하는 일 | API |
|---|---|---|
| `build-aab.yml` | AAB 빌드 + Play 업로드 | `edits.insert` → `edits.bundles.upload` → `edits.tracks.update` → `edits.commit` |
| `play-status.yml` | 읽기 전용 상태 조회 | `edits.insert` → `tracks/bundles/listings.list` → **`edits.delete`** |
| `play-release-name.yml` | 출시 이름 라벨만 수정 | `edits.insert` → `edits.tracks.patch` → `edits.commit` |

`build-aab.yml`은 업로드를 `r0adkll/upload-google-play` 액션에 위임한다(커밋 SHA로 핀 고정 —
서비스 계정 키를 다루므로 태그로 바꾸지 마라). `play-status.yml`은 `google-auth` + `requests`로
직접 호출한다.

출시 전 `pubspec.yaml`의 `version:`을 반드시 올려라 — 빌드 번호가 Play에 이미 있는 최대
버전 코드보다 커야 한다.

## 작업별 진입점

**출시하기** — 로컬 툴체인 없이 CI에서:
```bash
gh workflow run build-aab.yml -f track=internal -f build_number=10
```
`track`은 기본 `none`(빌드만, 업로드 안 함). `production`으로 갈 때는
`release_status=draft`로 스테이징하는 게 안전하다. `release_notes_locale`은
스토어 리스팅에 실제로 있는 로케일이어야 하고, 아니면 업로드 전체가 거부된다.

**상태 확인** — `gh workflow run play-status.yml`. Play Console을 열 필요가 없다.

**출시 이름만 수정** — `play-release-name.yml`. 기본 `apply=false`(미리보기).
`apply=true`이면서 `confirm`에 대상 버전 코드를 반복해야 실제로 commit한다.

## 레퍼런스를 언제 읽을지

`references/`에 문서를 통째로 넣어뒀다. 인터넷 없이도 정확한 시그니처를 확인할 수 있다.

- **`references/METHOD-REFERENCE.md`** — 143개 메서드 전체(HTTP verb, 전체 URL, 파라미터 표,
  요청/응답 스키마). 맨 앞에 인덱스 표가 있으니 거기서 메서드를 찾고 해당 절만 읽어라.
  파일이 크므로(125KB) 통째로 읽지 말고 grep으로 메서드명을 찾아 들어가라.
- **`references/androidpublisher-v3-discovery.json`** — 정본 스펙(discovery revision `20260803`,
  16 resources / 143 methods / 383 schemas). 요청 본문의 정확한 필드 구조가 필요할 때
  `schemas` 항목을 보면 된다. API 변경을 추적하려면 최신 리비전을 새로 받아 이 파일과 diff하면 된다:
  `curl "https://androidpublisher.googleapis.com/\$discovery/rest?version=v3"`
- **`references/guides/`** — 산문 가이드. 특히:
  - `android-publisher-edits.md` — edit 트랜잭션 모델
  - `android-publisher-tracks.md` — 트랙, 단계적 출시(`userFraction`), 릴리스 상태
  - `android-publisher-upload.md` — 업로드 상세(가장 김)
  - `android-publisher-getting_started.md` / `-authorization.md` — 서비스 계정, 스코프
  - `android-publisher-quotas.md` — 버킷별 기본 3000 QPM, 버킷 간 독립

## 함정

- **`edits.bundles.upload`는 느리다.** 공식 문서가 HTTP 타임아웃을 **2분 이상**으로 올리라고
  명시한다. 클라이언트 기본 타임아웃(보통 30~60초)이면 큰 AAB에서 끊긴다.
- **단수형 `track` 파라미터는 deprecated다.** 업로드 액션에서는 복수형 `tracks`를 쓴다.
  비워두면 production으로 간주되니 명시적으로 채워라.
- **`PLAY_SERVICE_ACCOUNT_JSON`은 빌드 전에 검사해라.** 없으면 10분짜리 빌드가 끝난 뒤에
  실패한다. 기존 워크플로들이 전부 앞단에서 fail-fast 하는 이유다.
- **비밀은 절대 커밋하지 마라.** 이 저장소는 공개다. 서비스 계정 JSON, 키스토어,
  base64 블롭 모두 GitHub Secrets로만 다룬다.
- 409 계열 충돌은 대개 **열려 있는 edit이 남아 있어서**다. 새 edit을 열기 전에 이전 것을
  지웠는지 확인해라.
