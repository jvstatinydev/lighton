import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';


import 'package:torch_controller/torch_controller.dart';

void main() async {
  TorchController().initialize();
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();

  await FFLocalizations.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

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
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
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

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    Future.delayed(Duration(milliseconds: 1000),
        () => safeSetState(() => _appStateNotifier.stopShowingSplashImage()));
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
