# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

"Light On - Flashlight" (`light_on_flashlight`) is a single-screen Flutter flashlight app for Android, iOS, and web. The torch is toggled through the `torch_controller` plugin, and the app monetizes with AdMob banners (`google_mobile_ads`). It targets Flutter *stable* and Dart SDK `^3.12.0`.

## Originally a FlutterFlow export — no longer round-tripped

`lib/` started life as FlutterFlow output (see the commit history: "Updating to latest FlutterFlow output"), but the project is **no longer exported from FlutterFlow**. Everything here is hand-maintained now: edit whatever file the change belongs in, including `lib/flutter_flow/`, and don't route a change through `custom_code/` just to keep it "export-safe."

What the FlutterFlow heritage still means in practice:

- The naming and layering conventions below (`FFAppState`, `FlutterFlowModel`, `FFRoute`, `FFLocalizations`, `<name>_widget.dart` + `<name>_model.dart`) are the house style — follow them so the codebase stays internally consistent.
- Generated widget code is deeply nested and verbose (long `override(...)` text-style chains, `animationsMap`). That is expected; match the surrounding style rather than reformatting it wholesale.
- `lib/custom_code/actions/` (exports registered in `index.dart`) and `lib/flutter_flow/custom_functions.dart` are still excluded from the analyzer in `analysis_options.yaml`, so mistakes there won't be caught by `flutter analyze`.

## Android release / Play Store

Google Play requires target API 36 (Android 16) for updates published after 2026-08-31, and the toolchain is pinned to what that needs:

- `compileSdk` / `targetSdk` **36**, `minSdk` 23, `ndkVersion 28.2.13676358` — `android/app/build.gradle`
- **The shipped `minSdk` is 24, not the 23 declared above.** `google_mobile_ads` declares `minSdk 24` in its own `android/build.gradle`, and manifest merging takes the highest value, so the AAB Play receives targets API 24. The plugin raised it in **7.0.0** (5.1.0 was 21, 6.0.0 was 23, 7.0.0 onward is 24); the Google Mobile Ads Android SDK itself is unaffected — `play-services-ads` AARs still declare `minSdkVersion="23"`. This is what dropped ~1,195 supported devices (all Android 6.0 / API 23) when the dependency was updated, and it is why Play Console warned about lost device support. Nothing in the plugin changelog records the bump; only its `build.gradle` does. Reverting means giving up the ads SDK that target API 36 compliance needs, so the bump is accepted rather than worked around — do not try to force API 23 back with `tools:overrideLibrary`, since the SDK genuinely requires 24 at runtime.
- AGP **8.11.1**, Kotlin **2.3.20** — `android/settings.gradle`. Kotlin is ahead of Flutter's minimum because `play-services-ads` 25.3.0 ships Kotlin 2.3.0 metadata.
- Gradle **8.14** — `android/gradle/wrapper/gradle-wrapper.properties`. Gradle 9 removed `Project.buildDir`, which `android/build.gradle` still uses, so 9.x needs separate work first.
- Java/JVM target 17 everywhere (app module plus the `subprojects` block in `android/build.gradle`).

**Signing** — `buildTypes.release` uses the upload key when `android/key.properties` exists and falls back to the debug key when it doesn't, so local `flutter run --release` keeps working. `key.properties` and `*.jks` are gitignored; the repository is public, so never commit or paste keystores, passwords, or base64 keystore blobs.

**CI builds** (`.github/workflows/`) — Android builds are verified in GitHub Actions, not locally:

| Workflow | Output | Signing | Use |
|---|---|---|---|
| `build-apk.yml` | `.apk` | debug key | sideload onto a phone to check behavior |
| `build-aab.yml` | `.aab` | upload key from GitHub Secrets | Play Console upload, and optionally the upload itself |
| `play-status.yml` | console output | — | read-only Play track/bundle/listing query, no local browser needed |
| `play-release-name.yml` | console output | — | fix a published release's **name label** only, without uploading anything |

`build-apk.yml` runs on every push to `claude/**`. Its Analyze step uses `--no-fatal-warnings --no-fatal-infos`, so **a green run does not mean the code is warning-free** — read the step's `N issues found` line before claiming analyzer warnings are fixed.

`play-status.yml` and `play-release-name.yml` both authenticate with `PLAY_SERVICE_ACCOUNT_JSON` and open a Play "edit" because the API requires one. `play-status.yml` never commits and always deletes the edit, so it is read-only. `play-release-name.yml` defaults to `apply=false` (preview only, edit deleted) and commits only when `apply=true` *and* `confirm` repeats the target version code.

`build-aab.yml` reads `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`; it fails fast if any is missing and deletes the restored keystore with `if: always()`.

**Publishing to Play from CI** — `build-aab.yml` can push the AAB to Play itself via the Google Play Developer API, so a release needs no local toolchain and no browser:

```bash
gh workflow run build-aab.yml -f track=internal -f build_number=10
```

The `track` input defaults to `none`, which keeps the historical behavior (build the artifact, upload nothing). Any other value (`internal`/`alpha`/`beta`/`production`) turns on the upload step and requires a fifth secret, `PLAY_SERVICE_ACCOUNT_JSON` — the full JSON key of a Play Console service account, checked before the build so a missing secret fails in seconds rather than after a ten-minute build. `release_status=draft` stages the release in Play Console without releasing it, which is the safe way to drive `track=production`. Release notes are optional (`release_notes`, `release_notes_locale`); the locale must be one the store listing actually has, or the API rejects the whole upload. The uploader action is pinned by commit SHA, not tag, because it handles the service account key.

Bump `version:` in `pubspec.yaml` before each release — the build number must exceed the highest version code already on Play.

## Commands

```bash
flutter pub get                      # install dependencies
flutter run                          # run on a connected device/emulator/browser
flutter test                         # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter analyze                      # static analysis (uses analysis_options.yaml)
dart format lib/                     # format

flutter build apk                    # Android APK
flutter build appbundle              # Android AAB (Play Store)
flutter build ios                    # iOS
flutter build web                    # web
```

**Launcher icons are committed, not generated at build time.** `android/app/src/main/res/mipmap-*/ic_launcher.png` (48/72/96/144/192 px) are checked in and are what the manifest's `android:icon="@mipmap/ic_launcher"` resolves to. The master image is `assets/images/app_launcher_icon.png` (512×512) — **if you change it, you must regenerate the five mipmaps and commit them**, or the app keeps shipping the old icon.

This bit us once: the mipmaps sat at Flutter's default icon for the project's whole history because nothing in CI ran a generator, so the first release built in CI (version code 13) shipped the default Flutter logo instead of the app's. `pubspec.yaml` still carries a `flutter_launcher_icons:` block configuring an `android: 'launcher_icon'` output name, but nothing runs it and no `mipmap-*/launcher_icon.png` exists — treat that block as inert unless you deliberately run `dart run flutter_launcher_icons` and commit what it produces (note it also rewrites the manifest's icon reference). The splash is configured in `flutter_native_splash.yaml` and has the same "only regenerates when someone runs it" caveat.

## Architecture

**Entry point** — `lib/main.dart` initializes `TorchController`, the theme, and localizations, then runs `MyApp` (a `MaterialApp.router`) wrapped in a `ChangeNotifierProvider<FFAppState>`. It declares ~80 supported locales; theme mode and locale are persisted via `shared_preferences`.

**State** — `lib/app_state.dart` (`FFAppState`) is a singleton `ChangeNotifier` holding app-wide state (`isFlashOn`). Mutate through `FFAppState().update(() { ... })` so listeners rebuild.

**Actions** — the app separates two kinds of logic:
- *Action blocks* in `lib/actions/actions.dart` orchestrate flow and state (e.g. `toggleFlashlightThenUpdateState` calls the custom action then writes to `FFAppState`).
- *Custom actions* in `lib/custom_code/actions/` are the low-level device calls (the actual `torch_controller` toggle / status read).

**Pages** — each screen is a `<name>_widget.dart` + `<name>_model.dart` pair under `lib/pages/`. The model extends `FlutterFlowModel` and holds per-page widget state; the widget wires up `createModel(...)`, on-page-load actions (via `SchedulerBinding.addPostFrameCallback`), and `flutter_animate` animations stored in an `animationsMap`. There is currently one page: `home_page`. Pages are re-exported from `lib/index.dart`.

**Navigation** — `lib/flutter_flow/nav/nav.dart` builds a `go_router` config. Routes are declared as `FFRoute` (a wrapper adding transitions, async param loading, and auth gating) and mapped to `GoRoute`s. `AppStateNotifier` drives the initial splash-image gate. Add a new screen by exporting it from `index.dart` and adding an `FFRoute` here.

**Internationalization** — `lib/flutter_flow/internationalization.dart` (`FFLocalizations`) provides string lookups keyed per-page; the language selector widget lives in `flutter_flow/`.

## Notes

- `pubspec.yaml` declares only packages the code actually imports, using caret constraints (`^1.2.3`); there are no `dependency_overrides`. Platform implementation packages (`*_android`, `*_web`, `*_platform_interface`) are pulled in transitively and must not be listed. `pubspec.lock` **is** committed so CI resolves the same versions.
- `test/widget_test.dart` is the default FlutterFlow smoke test and calls `MyApp()` with no args; it is a placeholder, not real coverage.
- The AdMob application ID is configured natively (Android: `android/app/src/main/AndroidManifest.xml`) rather than in Dart — look there when changing ad setup. The banner ad unit is inline in `lib/pages/home_page/home_page_widget.dart`.
- Since targetSdk 35+, Android draws edge-to-edge and the app cannot opt out. The home page's `SafeArea` is what keeps the app bar clear of the status bar and the bottom ad banner clear of the gesture bar — re-check both on a real device after touching that layout.
