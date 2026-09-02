import 'dart:async' show unawaited;

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '/flutter_flow/admob_util.dart' show ensureAdMobReady;
import '/flutter_flow/billing_util.dart' show ensureBillingReady;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/home_widget_util.dart'
    show initHomeWidgetChannel, refreshHomeWidgets;
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';

void main() async {
  // 예전에는 여기서 TorchController().initialize() 를 호출했는데,
  // WidgetsFlutterBinding.ensureInitialized() 보다도 앞이었다. 지금은 플래시
  // 초기화가 따로 없다 — 첫 사용 시점에 카메라를 조회한다.
  WidgetsFlutterBinding.ensureInitialized();

  // 안드로이드 15(SDK 35) 부터는 시스템이 앱을 화면 끝까지 그리게 하고 상태바와
  // 내비게이션 바를 그 위에 겹쳐 그린다(edge-to-edge). 그 아래 버전에서는 시스템
  // 바가 여전히 화면을 나눠 갖는다. 즉 같은 앱이 안드로이드 버전에 따라 다르게
  // 배치되고, 에뮬레이터(API 36)에서 확인한 그림이 옛 기기에서도 같다는 보장이
  // 없다. 실제로 API 34 캡처에서는 내비게이션 바가 불투명한 검은 띠였다.
  //
  // 여기서 명시적으로 켜서 어느 버전에서든 같은 *배치*가 되게 한다. Play
  // Console 이 "이전 버전과의 호환성을 위해 enableEdgeToEdge() 를 호출하세요"
  // 라고 안내하는 그 자리다. AndroidX 의 그 확장 함수는 ComponentActivity 에
  // 붙어 있는데 FlutterActivity 는 android.app.Activity 를 상속하므로 그대로는
  // 쓸 수 없고, Flutter 에서는 이 호출이 같은 일을 한다.
  //
  // 배치까지만이다. API 34 에뮬레이터로 확인해 보면 창은 이제 API 36 과 같은
  // 하단 24dp 인셋을 받지만, 화면은 여전히 다르다 -- 내비게이션 바가 불투명한
  // 검은 띠로 남는다. 바의 *색*은 이 모드가 아니라 SystemUiOverlayStyle 이
  // 정하고 그 기본값이 불투명하기 때문이다. 색까지 맞추려면 statusBarColor 와
  // systemNavigationBarColor 를 투명으로 둬야 하는데, 그게 바로 Play 의 다른
  // 안내가 "deprecated" 라고 지목하는 API 라서 건드리지 않는다.
  //
  // 비켜야 할 폭은 home_page 의 SafeArea 가 이미 처리한다 -- 이 호출은 그
  // 처리를 옛 버전에도 적용시킬 뿐, 새로 필요하게 만들지 않는다. API 29 미만
  // 에서는 아무 일도 하지 않는다.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();

  await FFLocalizations.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  // EEA 사용자를 위한 AdMob 동의(UMP) 흐름 + 광고 SDK 초기화. 최대한 일찍
  // 시작하되, 네트워크가 없거나 동의를 거부해도 손전등 기능이 막히면 안 되므로
  // 여기서는 완료를 기다리지 않는다. 배너 쪽이 같은 Future 를 await 하므로
  // 광고 요청이 초기화를 앞질러 나가는 일은 없다.
  unawaited(ensureAdMobReady());

  // "광고 제거" 권한 확인. 같은 이유로 기다리지 않는다 -- Play 가 없거나
  // 네트워크가 없어도 손전등은 즉시 동작해야 한다. 저장된 권한은 위의
  // initializePersistedState() 가 이미 읽었으므로 첫 프레임은 캐시로 그리고,
  // 조회가 끝나면 FFAppState 가 알려서 다시 그려진다.
  unawaited(ensureBillingReady());

  // 홈 화면 위젯. 위젯이 앱을 띄우며 넘긴 동작을 받을 채널을 열고, 놓여 있는
  // 위젯을 한 번 다시 그리게 한다. 저장된 구매 상태나 언어가 위젯이 마지막으로
  // 그려진 뒤 바뀌었을 수 있다. 기다리지 않는다 -- 위젯은 손전등이 아니다.
  initHomeWidgetChannel();
  unawaited(refreshHomeWidgets());

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = FFLocalizations.getStoredLocale();

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  // go_router 17부터 RouteMatchList.matches는 List<RouteMatchBase>이므로
  // 파라미터 타입도 RouteMatchBase로 넓힌다.
  String getRoute([RouteMatchBase? routeMatch]) {
    final RouteMatchBase lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
    FFLocalizations.storeLocale(language);
    // 홈 화면 위젯도 앱에서 고른 언어를 따른다(WidgetPrefs.kt). 저장이 끝난
    // 뒤에 다시 그려야 새 언어로 나온다.
    unawaited(refreshHomeWidgets());
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Light On - Flashlight',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
        Locale('ja'),
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        Locale('it'),
        Locale('fr'),
        Locale('de'),
        Locale('nl'),
        Locale('es'),
        Locale('ar'),
        Locale('vi'),
        Locale('ta'),
        Locale('th'),
        Locale('tr'),
        Locale('uk'),
        Locale('id'),
        Locale('ms'),
        Locale('pl'),
        Locale('pt'),
        Locale('sv'),
        Locale('da'),
        Locale('hu'),
        Locale('el'),
        Locale('he'),
        Locale('hi'),
        Locale('lv'),
        Locale('ne'),
        Locale('mn'),
        Locale('uz'),
        Locale('sl'),
        Locale('ro'),
        Locale('ml'),
        Locale('no'),
        Locale('ru'),
        Locale('sk'),
        Locale('fa'),
        Locale('af'),
        Locale('az'),
        Locale('am'),
        Locale('eu'),
        Locale('be'),
        Locale('bn'),
        Locale('my'),
        Locale('bs'),
        Locale('bg'),
        Locale('km'),
        Locale('sq'),
        Locale('cs'),
        Locale('hr'),
        Locale('et'),
        Locale('hy'),
        Locale('fi'),
        Locale('ka'),
        Locale('gu'),
        Locale('is'),
        Locale('gl'),
        Locale('kn'),
        Locale('kk'),
        Locale('lo'),
        Locale('mk'),
        Locale('mr'),
        Locale('lt'),
        Locale('ca'),
        Locale('or'),
        Locale('pa'),
        Locale('ps'),
        Locale('sr'),
        Locale('sm'),
        Locale('si'),
        Locale('sw'),
        Locale('te'),
        Locale('sd'),
        Locale('tl'),
        Locale('ur'),
        Locale('ky'),
        Locale('zu'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
