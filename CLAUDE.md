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
- AGP **8.13.2** (the last 8.x), Kotlin **2.3.20** — `android/settings.gradle`. Kotlin is ahead of Flutter's minimum because `play-services-ads` 25.3.0 ships Kotlin 2.3.0 metadata; AGP is ahead of it because `android.r8.optimizedResourceShrinking` only exists from 8.12, and because 8.13.2's R8 is the one that reads Kotlin 2.3 metadata (R8 parses it once optimization is on).
- Gradle **8.14** — `android/gradle/wrapper/gradle-wrapper.properties`. Gradle 9 removed `Project.buildDir`, which `android/build.gradle` still uses, so 9.x needs separate work first.
- Java/JVM target 17 everywhere (app module plus the `subprojects` block in `android/build.gradle`).

**R8** — the release build shrinks, optimizes, and shrinks resources; `test/android_build_config_test.dart` guards the settings below, because breaking them is invisible in a green build and only surfaces as a Play Console warning:

- `minifyEnabled true` / `shrinkResources true` in `android/app/build.gradle`. The Flutter Gradle plugin already turns both on for release (`FlutterPluginUtils.shouldShrinkResources`, off only with `-Pshrink=false`), so this is declaration, not a change of behavior.
- **`proguard-android-optimize.txt`, never `proguard-android.txt`.** The plain file contains `-dontoptimize`, and a single rule file carrying it switches off R8's optimization pass for the whole build. This app shipped that way through version code 21: Flutter added the `-optimize` default and `android/app/build.gradle` added the plain one on top, which is what Play Console's "optimization not enabled" advisory on 1.0.7 was reporting. AGP 9 removes support for the plain file outright.
- `android.r8.optimizedResourceShrinking=true` in `android/gradle.properties` — Play reports this separately as "optimized resource shrinking". It makes R8 analyze resources and DEX in one pass so it can drop resources and the code that reads them together. AGP 8.12–8.13 need the flag; AGP 9 does it by default whenever `shrinkResources` is on.

**Why not AGP 9 yet**, which Play's same advisory asks for: AGP 9.0 requires Gradle **9.1**, and `android/build.gradle` still assigns `rootProject.buildDir` / `project.buildDir`, both removed in Gradle 9. On top of that AGP 9 makes built-in Kotlin the default (Flutter 3.44 can only opt *out* with `android.builtInKotlin=false`; enabling it needs Flutter 3.47+), replaces `BaseExtension` with new DSL interfaces that the Flutter Gradle plugin has not migrated to ([flutter#184410](https://github.com/flutter/flutter/issues/184410) is open and unowned), and turns on `android.proguard.failOnMissingFiles`. That is a multi-part migration resting on escape hatches, and it buys nothing Play is warning about that AGP 8.13.2 does not already deliver — both optimization items are satisfied here.

**Signing** — `buildTypes.release` uses the upload key when `android/key.properties` exists and falls back to the debug key when it doesn't, so local `flutter run --release` keeps working. `key.properties` and `*.jks` are gitignored; the repository is public, so never commit or paste keystores, passwords, or base64 keystore blobs.

**CI builds** (`.github/workflows/`) — Android builds are verified in GitHub Actions, not locally:

| Workflow | Output | Signing | Use |
|---|---|---|---|
| `build-apk.yml` | `.apk` | debug key | sideload onto a phone to check behavior |
| `build-aab.yml` | `.aab` | upload key from GitHub Secrets | Play Console upload, and optionally the upload itself |
| `play-status.yml` | console output | — | read-only Play track/bundle/listing query, no local browser needed |
| `play-release-name.yml` | console output | — | fix a published release's **name label** only, without uploading anything |
| `play-release-notes.yml` | console output | — | fill in or fix a release's **release notes** in every locale, without uploading anything |
| `play-track-clear.yml` | console output | — | empty a **test** track's active releases (stale builds left on beta/alpha/internal) |
| `emulator-check.yml` | screenshots + logcat | debug key | run the app on a CI emulator and read what only a device would show — see the `adb` note under Notes |

`build-apk.yml` runs on every push to `main`, `flutterflow`, and `claude/**`. `main` is included because a feature branch is only ever built against the base it branched from — a set of individually-green PRs can still combine into a broken `main`, and without this the merged result would never be built. Its Analyze step uses `--no-fatal-warnings --no-fatal-infos`, so **a green run does not mean the code is warning-free** — read the step's `N issues found` line before claiming analyzer warnings are fixed.

`play-status.yml`, `play-release-name.yml`, `play-release-notes.yml`, and `play-track-clear.yml` all authenticate with `PLAY_SERVICE_ACCOUNT_JSON` and open a Play "edit" because the API requires one. `play-status.yml` never commits and always deletes the edit, so it is read-only. The other three default to `apply=false` (preview only, edit deleted) and commit only when `apply=true` *and* `confirm` repeats the target — the version code for `play-release-name.yml` and `play-release-notes.yml`, the track name for `play-track-clear.yml`.

**Release notes live in `release-notes/<version code>/<locale>.txt`, not in a workflow input.** `build-aab.yml`'s `release_notes` input takes a single locale, so a release driven by that input alone ships notes in one language and silently leaves every other store locale blank — which is how version code 16 first went up. When the directory for the version code being uploaded exists, `build-aab.yml` uploads every locale in it and ignores the single-locale input; the input is only the fallback for a version that has no directory yet. Play rejects the whole upload if any locale is absent from the store listing, and caps each locale at 500 characters — `play-release-notes.yml` checks both against the live listing before sending anything. See `release-notes/README.md`.

`play-track-clear.yml` empties a track by PUTting `releases: []` — the `Track` schema defines `releases` as "desired changes" on an update, so an empty list drops every active release. `status: halted` is not an option here: halting needs an earlier `completed` release to fall back to, and a stale test track usually holds exactly one. The bundles survive, so re-adding the same version code restores the track. **`production` is deliberately absent from the track choices** (and re-checked in the script) because emptying it would pull the app from the store.

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

## Home screen widgets (Android)

Four Android app widgets, one per size, gated behind the "remove ads" purchase. Everything lives in `android/app/src/main/kotlin/com/mycompany/lightonflashlight/` and `android/app/src/main/res/`; Dart only pokes the native side through `lib/flutter_flow/home_widget_util.dart` (channel `lighton/widgets`, native `WidgetPlugin.kt`).

- **One `<receiver>` per size** (`TorchWidget1x1/2x2/4x2/4x4`, all subclasses of `TorchWidgetProvider`) so the widget picker lists "손전등 (작게/중간/넓게/크게)" separately and each drops at its own size. This is deliberate: a single resizable widget was rejected because the target users (older people) won't resize one. `resizeMode` is still on, down to 1×1. Sizes are declared in `res/xml/widget_torch_*.xml` (`70 × cells − 30` dp plus `targetCellWidth/Height` for Android 12+). An in-app "add widget to home screen" button (`requestPinAppWidget`) was **deliberately left for a later release**.
- **All four layouts share the same id set** (`widget_root`, `widget_torch`, `widget_button`, `widget_icon`, `widget_label`, `widget_title`, `widget_locked`, …), with unused views `gone`. `RemoteViews` fails at render time ("Problem loading widget") if code sets a view id a layout lacks, and the Android build doesn't catch it, so `test/home_widget_config_test.dart` cross-checks every `R.id.*` in `TorchWidgetProvider.kt` against every layout, every `R.string.*` against every `values-*/strings.xml` (a missing locale silently falls back to English), and `values-night/colors.xml` against `values/colors.xml`.
- **Tapping toggles without opening the app.** The click is a broadcast `PendingIntent` (`ACTION_WIDGET_TOGGLE`) to the provider, which calls `CameraManager.setTorchMode` from Kotlin. The camera choice (`TorchDevice.selectCameraId`) **duplicates** `selectTorchCamera` in `lib/flutter_flow/torch_util.dart` because Dart isn't running when a widget is tapped; change both together. Torch state is tracked process-wide by `TorchMonitor` (one `TorchCallback`, registered in `LightOnApplication.onCreate`), which also redraws the widgets whenever the torch changes — from the app, a widget, the notification, or another app opening the camera. `TorchPlugin` reads the same monitor, so the app's button and the widgets never disagree.
- **`TorchService` is a `specialUse` foreground service, and it is not optional.** `CameraService` links the torch to the calling process's binder and **turns the torch off when that process dies**. A receiver-only toggle therefore leaves the torch at the mercy of process reaping. The service exists only while the torch was turned on from a widget; turning off (from anywhere) goes straight to `setTorchMode(false)` and the service stops itself when the monitor reports "off". Other FGS types don't fit: `camera` needs runtime CAMERA permission the torch doesn't otherwise need, `shortService` dies after 3 minutes. **`specialUse` requires a Play Console declaration** (App content → Foreground service permissions: subtype `flashlight`, "keeps the flashlight on after the user turned it on from a home screen widget") before a build carrying it is submitted; without it Play review can reject the release. `POST_NOTIFICATIONS` is deliberately not requested — a receiver can't prompt — so on Android 13+ the "flashlight is on, tap to turn off" notification is hidden unless the user granted it, while the service still runs.
- **Purchase gating** reads the same `shared_preferences` file Dart writes (`FlutterSharedPreferences`, key `flutter.__ads_removed__`, see `WidgetPrefs.kt`). A locked widget shows a lock and "광고 제거로 잠금 해제"; its click is an *activity* `PendingIntent` that opens `MainActivity` with `launch_action=removeAds`, which the home page turns into `showRemoveAdsSheet`. Devices without a flash get `launch_action=toggle` instead (the widget can't light the screen; the app does). `billing_util._setEntitlement` and `MyApp.setLocale` call `refreshHomeWidgets()` after writing, because the widget only re-reads on redraw. The widget follows the app's stored language (`flutter.__locale_key__`), not the system one. It's a cache: after a reinstall, a buyer sees a locked widget until the app has been opened once, which is what the "이미 구매했다면 앱을 열어 주세요" line on the 4×4 is for.
- **Verifying**: `emulator-check.yml` sources `.github/scripts/emulator-widget.sh` after the app captures. Stage 1 broadcasts the widget's toggle action while locked and asserts nothing starts. Stage 2 drives the Pixel Launcher's widget picker with `uiautomator` (search "Light", expand the app row, scroll to "Flashlight (Large)", `input draganddrop` onto the workspace), screenshots the locked widget, taps it and checks the app came to the front (`06-widget-placed-locked.png`, `07-locked-widget-tapped.png`). Stage 3 does `adb root` (works on `google_apis` images), writes the purchase key into the prefs file with the app's uid as owner, and asserts the toggle broadcast starts `TorchService` and a second one stops it — this deterministic end-to-end check fails the job. Stage 4 taps the now-unlocked widget on the home screen and screenshots on/off (`08-`…`10-widget-*.png`). Two things the script had to learn: `am broadcast` from adb lacks the launcher's PendingIntent grant, so the FGS start is `DENIED` (uidState RCVR) unless the script first runs `cmd deviceidle tempwhitelist` for the package, which is the same temporary allowlist a real widget tap gets; and a denied start still leaves a `ServiceRecord`, so "service running" must be read from `isForeground=true`, not from the record's existence. `widget-log.txt` and `logcat-widget.txt` (tag `LightOnTorch`) carry the details. All four stages passed on the API 36 emulator on 2026-09-02.

## Skills

`.claude/skills/` carries two skills with the vendor documentation bundled offline, so neither needs network access or a login to answer questions:

- **`play-release`** — Google Play Developer API v3. The Play Console web UI is unreachable here (an anonymous session is redirected to the marketing page), so all Play work goes through the API instead. Bundles the machine-readable discovery spec (`revision 20260803`, 143 methods / 383 schemas), a generated method reference, and the prose guides. Use it when touching `build-aab.yml`, `play-status.yml`, or `play-release-name.yml`.
- **`samsung-rtl`** — Samsung Remote Test Lab, for reproducing device-only failures like the splash hang. Note RTL has **no public API**: device control is browser-only and even its adb bridge needs a human to click through, so it cannot be automated in CI. Try `emulator-check.yml` first — it needs no human and returns both screenshots and logcat — and keep RTL for what an emulator can't answer: real flash output, and vendor-specific behavior on actual Samsung hardware. Figure images were omitted to keep the repo small; each figure's caption and source URL are preserved.

## Notes

- `pubspec.yaml` declares only packages the code actually imports, using caret constraints (`^1.2.3`); there are no `dependency_overrides`. Platform implementation packages (`*_android`, `*_web`, `*_platform_interface`) are pulled in transitively and must not be listed. `pubspec.lock` **is** committed so CI resolves the same versions.
- `test/widget_test.dart` is the default FlutterFlow smoke test and calls `MyApp()` with no args; it is a placeholder, not real coverage.
- The AdMob application ID is configured natively (Android: `android/app/src/main/AndroidManifest.xml`) rather than in Dart — look there when changing ad setup. The banner ad unit is inline in `lib/pages/home_page/home_page_widget.dart`.
- Ads have an ordering requirement that is easy to break: `ensureAdMobReady()` (`lib/flutter_flow/admob_util.dart`) gathers UMP consent and calls `MobileAds.instance.initialize()`, and **every ad widget must `await` it before requesting an ad** — AdMob requires initialization first, and `canRequestAds()` is false until `requestConsentInfoUpdate()` has finished. `main()` kicks it off without awaiting so the torch never waits on the network; `FlutterFlowAdBanner` awaits the same shared Future. A banner that requests on the first frame instead will lose that race, which is what silently killed ads in 1.0.4+14.
- `kShowAdBannerDiagnostics` in `lib/flutter_flow/flutter_flow_ad_banner.dart` draws the load failure (error code, consent state) into the banner slot. It predates `emulator-check.yml`, which now reads the same failure out of logcat without touching the widget tree — prefer that, and reach for this constant only when you need the failure visible on a physical device. **Set it back to `false` before a Play release** (`test/release_guard_test.dart` enforces this on the AAB path); then a failed banner collapses to zero height instead of showing a black box.
- Since targetSdk 35+, Android draws edge-to-edge and the app cannot opt out. The home page's `SafeArea` is what keeps the app bar clear of the status bar and the bottom ad banner clear of the gesture bar — after touching that layout, run `emulator-check.yml` and read `insets.txt` next to the screenshots. The app prints a `System insets:` block per orientation (`lib/flutter_flow/edge_to_edge_util.dart`), so the width the layout has to avoid is a number rather than something you measure off a screenshot by eye. `main()` also calls `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)` so Android 10–14 **lay out** the same way — measured on the API 34 emulator, the window then reports the same `bottom 24.0dp` inset that API 36 does, instead of the navigation bar sitting outside it. It does **not** make those versions *look* the same: API 34 still paints an opaque black navigation bar and a scrim over the status bar, because the bar *colours* come from `SystemUiOverlayStyle` (whose defaults are opaque) and not from the UI mode. Chasing that would mean setting `statusBarColor`/`systemNavigationBarColor` transparent — the very APIs Play's *other* edge-to-edge notice calls deprecated — so it is deliberately left alone. Golden tests can't cover this: they render the widget tree without any Android system chrome.
- **Play Console's edge-to-edge advisory ("일부 사용자에게는 더 넓은 화면이 표시되지 않을 수 있습니다" / "Edge-to-edge may not display for all users"), raised against 1.0.7, is a false positive — there is nothing to fix in the layout.** Google's check looks for a call to AndroidX's `enableEdgeToEdge()` / `EdgeToEdge.enable()`, which no Flutter app emits: that extension hangs off `ComponentActivity`, and `FlutterActivity` extends `android.app.Activity`. Flutter's engine handles the enforced edge-to-edge window itself and reports the insets through `MediaQuery`. The Flutter team closed the same report as solved, saying it "will not impact your users" ([flutter/flutter#169810](https://github.com/flutter/flutter/issues/169810)). Do **not** switch `MainActivity` to `FlutterFragmentActivity` to reach that function, and do **not** add `android:windowOptOutEdgeToEdgeEnforcement` — targetSdk is 36, where the opt-out is gone and using it can crash.
  This was measured, not assumed, on the API 36 emulator: portrait insets are top 48.8dp / bottom 24.0dp, and in the screenshot the app bar paints one flat colour from y=0 down through the toolbar (so it fills the status-bar strip) while body content stops at exactly 63px = 24dp above the bottom — the gesture inset to the pixel. Landscape moves the cutout to the side (top 24.0 / bottom 24.0 / **left 48.8** / right 0.0) and the content clears that too.
- **`adb` is not available *locally*, but `emulator-check.yml` gives you logcat and screenshots from CI.** Don't propose `adb logcat` or `adb install` against a local device, and don't propose Samsung RTL's Remote Debug Bridge — none of those are a path anyone here can take. The emulator job is, and it is the **first** thing to reach for on any runtime question, ahead of building a sideloadable APK.

  It runs the emulator on the CI runner, where adb *does* exist, so `print`/`debugPrint` output stops being invisible. `flutter test` cannot replace it: the diagnostics worth reading (`Torch:\n…` from `lib/flutter_flow/torch_util.dart`, `AdMob readiness:\n…` from `lib/flutter_flow/admob_util.dart`) only appear when the real app runs on a real Android framework.

  ```
  Actions → Emulator Visual Check → Run workflow   (or dispatch emulator-check.yml)
  ```

  It builds the release APK, installs it, launches it, and uploads `emulator-out/`: five screenshots (portrait, landscape, landscape the other way, portrait again, after tapping the torch button) plus `logcat-full.txt`, `logcat-flutter.txt` (Dart output only), `logcat-relevant.txt` (ads/torch/camera lines), `insets.txt` (system-bar widths per orientation), and `rotation-log.txt` (what each capture actually got). It then runs the home-screen-widget stages (`widget-log.txt`, `06-`/`07-widget-*.png`; see the widgets section above). **Claude can read all of it** — `download_workflow_run_artifact` returns a signed URL, `curl` it, unzip, and `Read` the PNGs directly. So visual checks do not need a human to look at a phone.

  Three things to know before relying on it:

  - `workflow_dispatch` workflows only run when the file is on the **default branch**. Dispatching it from a feature branch that main doesn't have yet returns 404. Once it is on main you can dispatch it against any ref. Note this applies to the workflow *file*; `.github/scripts/emulator-capture.sh` is checked out from whatever ref you dispatch, so script changes take effect on a branch.
  - The API 36 emulator image exposes **one camera whose id is `1`, not `0`**, with flash available. That is exactly the device shape the `cameraIdList[0]` bug needed, so it is a free regression test for `selectTorchCamera` — and `setTorchMode` succeeds there. What it cannot tell you is whether light physically comes out.
  - **Rotation is only believable because the script re-reads it.** For its whole history the job silently produced portrait screenshots named `02-landscape`: `cmd window set-user-rotation` returns exit 0 on API 36 while doing nothing, so the `||` fallback chain never ran, and nobody read the `::warning::` on a green job. The current script tries four methods (`cmd window user-rotation`, the old `set-user-rotation`, `settings put system user_rotation`, then `adb emu rotate`), verifies each against `dumpsys` before moving on, and **fails the job** if a capture ends up in the wrong orientation. `dumpsys` also does not name rotations the way you request them: API 36 reports `mDisplayRotation=ROTATION_90` where the request is `1`, so the reading is normalised to the ordinal and both the degree and ordinal spellings are accepted. Check `rotation-log.txt` before drawing any conclusion from an orientation-dependent screenshot; it also records which window had focus, because an ANR dialog from another app once dimmed a whole capture.

  Fall back to the old loop only for what the emulator genuinely can't answer (actual light emission, a vendor-specific crash): put the failure into the widget tree, push to `claude/**` so `build-apk.yml` produces a sideloadable APK, install it, and read the answer off the phone. That round-trip used to be the normal cost of every device-only investigation; it is now the exception.
