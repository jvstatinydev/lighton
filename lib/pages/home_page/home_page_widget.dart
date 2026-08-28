import '/flutter_flow/edge_to_edge_util.dart' show logSystemInsets;
import '/flutter_flow/flutter_flow_ad_banner.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_language_selector.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/remove_ads_promo.dart'
    show RemoveAdsButton, kInlineRemoveAdsMinWidth;
import '/flutter_flow/screen_light_notice.dart'
    show showScreenLightNoticeOnce;
import '/flutter_flow/screen_light_util.dart' show setKeepAwake;
import '/flutter_flow/torch_util.dart'
    show kShowTorchDiagnostics, torchStatus, usesScreenLight;
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // 손전등 화면이 떠 있는 동안에는 화면이 저절로 꺼지지 않게 한다.
    // 불이 꺼져 있어도 마찬가지다. 다시 켜려고 잠금을 풀고 앱을 찾아 들어오는
    // 과정이 부담인 분들이 있다.
    setKeepAwake(true);

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isFlashOnInit = await actions.getFlashlightStatus();
      FFAppState().isFlashOn = _model.isFlashOnInit!;
      FFAppState().update(() {});

      // 플래시가 없어 화면을 조명으로 쓰는 기기라면, 왜 화면이 하얘지는지
      // 처음 한 번 설명한다. 위 호출로 카메라 조회가 끝나야 알 수 있다.
      if (usesScreenLight && mounted) {
        await showScreenLightNoticeOnce(context);
      }
      await Future.delayed(const Duration(milliseconds: 100));
      if (FFAppState().isFlashOn) {
        // button on animation
        if (animationsMap['buttonOnActionTriggerAnimation2'] != null) {
          await animationsMap['buttonOnActionTriggerAnimation2']!
              .controller
              .forward(from: 0.0);
        }
      } else {
        // button off animation
        if (animationsMap['buttonOnActionTriggerAnimation1'] != null) {
          await animationsMap['buttonOnActionTriggerAnimation1']!
              .controller
              .forward(from: 0.0);
        }
      }

      FFAppState().isFlashOn = !FFAppState().isFlashOn;
      safeSetState(() {});
      await Future.delayed(const Duration(milliseconds: 100));
      if (FFAppState().isFlashOn) {
        // button on animation
        if (animationsMap['buttonOnActionTriggerAnimation2'] != null) {
          await animationsMap['buttonOnActionTriggerAnimation2']!
              .controller
              .forward(from: 0.0);
        }
      } else {
        // button off animation
        if (animationsMap['buttonOnActionTriggerAnimation1'] != null) {
          await animationsMap['buttonOnActionTriggerAnimation1']!
              .controller
              .forward(from: 0.0);
        }
      }

      FFAppState().isFlashOn = !FFAppState().isFlashOn;
      safeSetState(() {});
    });

    animationsMap.addAll({
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 600.ms),
          FadeEffect(
            curve: Curves.easeIn,
            delay: 600.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          TiltEffect(
            curve: Curves.elasticOut,
            delay: 0.0.ms,
            duration: 200.0.ms,
            begin: Offset(0.393, 0),
            end: Offset(-0.393, 0),
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          TiltEffect(
            curve: Curves.elasticOut,
            delay: 0.0.ms,
            duration: 200.0.ms,
            begin: Offset(-0.393, 0),
            end: Offset(0.393, 0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    // 화면을 떠나면 원래대로 되돌린다. 창 단위 플래그라 앱이 백그라운드로
    // 가면 어차피 풀리지만, 명시적으로 정리해 둔다.
    setKeepAwake(false);
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    // 시스템 바가 먹은 폭을 logcat 에 한 번 남긴다. edge-to-edge 에서는 이
    // 값이 곧 아래 SafeArea 가 비켜줘야 하는 폭이라, 배치가 틀렸을 때 무엇과
    // 비교해야 하는지가 이 숫자다. 값이 바뀔 때만 찍으므로 프레임마다 쌓이지
    // 않는다(lib/flutter_flow/edge_to_edge_util.dart).
    logSystemInsets(context);

    // 플래시가 없어 화면을 조명으로 쓰는 기기에서, 조명이 켜져 있는 동안.
    // 이때는 테마(다크 모드 포함)와 무관하게 화면을 최대한 하얗게 만든다.
    // 빛을 내는 것이 목적이므로 색이 있는 영역은 그만큼 빛을 깎아먹는다.
    final screenLit = usesScreenLight && FFAppState().isFlashOn;

    // "광고 제거" 버튼을 배너 옆에 둘 수 있는 폭인지. 배너와 같은 기준을
    // 쓰므로 둘 중 한 곳에는 반드시 나온다 -- 어느 기기에서도 사라지지 않는다.
    final roomForInlineButton =
        MediaQuery.sizeOf(context).width >= kInlineRemoveAdsMinWidth;

    return Opacity(
      // 화면을 조명으로 쓰는 동안에는 빛을 깎지 않는다.
      opacity: screenLit ? 1.0 : 0.9,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: screenLit
              ? Colors.white
              : FlutterFlowTheme.of(context).secondaryBackground,
          appBar: AppBar(
            backgroundColor: screenLit
                ? Colors.white
                : FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            title: Text(
              FFLocalizations.of(context).getText(
                'iq5z1i00' /* 손전등 */,
              ),
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.interTight(
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
                    color: screenLit
                        ? Colors.black
                        : FlutterFlowTheme.of(context).primaryText,
                    fontSize: 22.0,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
            ),
            actions: [
              // 배너 왼쪽 여백이 좁아 거기에 버튼을 둘 수 없는 기기에서만
              // 상단바로 올린다. 배너는 320dp 고정이라 360dp 화면에서는
              // 남는 자리가 40dp 뿐이고, 거기에 버튼을 넣으면 광고와 붙어서
              // 무효 클릭 위험이 생긴다.
              if (!FFAppState().adsRemoved && !roomForInlineButton)
                RemoveAdsButton(
                  // 상단바에서는 언제나 글자를 보여준다. 아이콘만 있으면
                  // 무엇을 하는 버튼인지 알 수 없고, 여기는 배너 옆 여백과
                  // 달리 폭이 광고 크기에 묶여 있지 않다.
                  showLabel: true,
                  color: screenLit
                      ? Colors.black
                      : FlutterFlowTheme.of(context).secondaryText,
                ),
              // 언어 선택기는 원래 본문에 한 줄을 따로 차지하고 있었다.
              // 상단바로 올리면 세로 한 단이 통째로 비어서, 글꼴을 크게 키운
              // 사용자에게 안내 문구가 잘리는 것도 그만큼 덜해진다.
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8.0),
                child: FlutterFlowLanguageSelector(
                  width: MediaQuery.sizeOf(context).width * 0.45,
                  // 상단바 색을 그대로 비친다. 예전에는 테마색을 직접 넣어서
                  // 화면이 하얘졌을 때 여기만 색이 남아 이질감이 있었다.
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  borderRadius: 0.0,
                  dropdownColor: screenLit
                      ? Colors.white
                      : FlutterFlowTheme.of(context).secondaryBackground,
                  dropdownIconColor: screenLit
                      ? Colors.black
                      : FlutterFlowTheme.of(context).secondaryText,
                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        color: screenLit
                            ? Colors.black
                            : FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                      ),
                  hideFlags: false,
                  flagSize: 16.0,
                  flagTextGap: 8.0,
                  currentLanguage: FFLocalizations.of(context).languageCode,
                  languages: FFLocalizations.languages(),
                  onChanged: (lang) => setAppLanguage(context, lang),
                ),
              ),
            ],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!valueOrDefault<bool>(
                        FFAppState().isFlashOn,
                        true,
                      ))
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await action_blocks
                                    .toggleFlashlightThenUpdateState(context);
                                if (animationsMap[
                                        'buttonOnActionTriggerAnimation2'] !=
                                    null) {
                                  await animationsMap[
                                          'buttonOnActionTriggerAnimation2']!
                                      .controller
                                      .forward(from: 0.0);
                                }
                              },
                              text: FFLocalizations.of(context).getText(
                                'c0ob4q61' /* 꺼짐 */,
                              ),
                              options: FFButtonOptions(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: MediaQuery.sizeOf(context).height * 0.5,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).alternate,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 60.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap['buttonOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                      if (valueOrDefault<bool>(
                        FFAppState().isFlashOn,
                        true,
                      ))
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await action_blocks
                                    .toggleFlashlightThenUpdateState(context);
                                if (animationsMap[
                                        'buttonOnActionTriggerAnimation1'] !=
                                    null) {
                                  await animationsMap[
                                          'buttonOnActionTriggerAnimation1']!
                                      .controller
                                      .forward(from: 0.0);
                                }
                              },
                              text: FFLocalizations.of(context).getText(
                                '24qab3qx' /* 켜짐 */,
                              ),
                              options: FFButtonOptions(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: MediaQuery.sizeOf(context).height * 0.5,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconAlignment: IconAlignment.start,
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: screenLit
                                    ? Colors.white
                                    : Color(0xFF38B6A8),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: screenLit
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 60.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap['buttonOnActionTriggerAnimation2']!,
                            ),
                          ),
                        ),
                    ],
                  ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
                ),
                if (kShowTorchDiagnostics)
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      torchStatus.describe(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // 화면을 조명으로 쓰는 동안에만 배너를 감춘다. 그때는 배너가
                // 빛을 깎아먹기만 하고, 화면을 등지고 비추는 상황이라 광고를
                // 볼 사람도 없다. 조명을 끄면 다시 보인다.
                //
                // 위젯을 빼지 않고 hideAd 로 넘기는 이유는 레이아웃 때문이다.
                // 통째로 빼면 그 높이만큼 화면이 출렁인다.
                //
                // 반대로 광고를 산 사람에게는 통째로 뺀다. 여기서는 출렁일
                // 일이 없다 -- 조명처럼 껐다 켰다 하는 상태가 아니라 한 번
                // 사면 영구히 사라지는 상태이기 때문이다. 이 위젯은 배너뿐
                // 아니라 "광고 제거" 프로모도 그리므로, 이미 산 사람에게는
                // 둘 다 필요 없다.
                if (!FFAppState().adsRemoved)
                  FlutterFlowAdBanner(
                    showsTestAd: false,
                    androidAdUnitID: 'ca-app-pub-3228085068090706/4930787659',
                    hideAd: screenLit,
                    showInlineButton: roomForInlineButton,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
