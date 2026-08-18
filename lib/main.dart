import 'dart:async' show unawaited;

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '/flutter_flow/admob_util.dart' show ensureAdMobReady;
import '/flutter_flow/billing_util.dart' show ensureBillingReady;
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';

void main() async {
  // 예전에는 여기서 TorchController().initialize() 를 호출했는데,
  // WidgetsFlutterBinding.ensureInitialized() 보다도 앞이었다. 지금은 플래시
  // 초기화가 따로 없다 — 첫 사용 시점에 카메라를 조회한다.
  WidgetsFlutterBinding.ensureInitialized();
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
