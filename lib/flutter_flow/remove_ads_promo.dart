import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import '../app_state.dart';
import 'billing_util.dart';
import 'flutter_flow_theme.dart';
import 'internationalization.dart';

/// 배너를 오른쪽 정렬했을 때 왼쪽 여백에 버튼을 두려면 최소 이만큼은 있어야 한다.
///
/// 배너는 320dp 고정이다(flutter_flow_ad_banner.dart 참고). 화면이 360dp 면
/// 남는 자리가 40dp 뿐인데, 거기에 버튼을 넣으면 광고와 사실상 붙는다.
/// 버튼을 노리다 광고를 잘못 누르면 무효 클릭이 되고 반복되면 계정이 정지된다.
/// 그래서 버튼 48dp + 죽은 공간 8dp 를 확보할 수 있을 때만 여백에 두고,
/// 좁으면 상단바로 올린다.
const double kInlineRemoveAdsMinWidth = 320.0 + 48.0 + 8.0;

/// 여백에 아이콘 대신 글자를 넣으려면 이만큼은 있어야 한다.
///
/// 아이콘만 있으면 무엇을 하는 버튼인지 알 수 없다는 지적을 받았다. 맞는
/// 말이라 자리가 되면 글자를 보여준다. 다만 아이콘과 글자를 **함께** 넣을
/// 자리는 없다 -- 411dp 화면이라도 여백이 91dp 뿐이라, 아이콘까지 넣으면
/// 글자가 잘린다. 그래서 글자를 보여줄 때는 아이콘을 뺀다. 뜻을 전하는 쪽은
/// 글자다. 320 + 버튼 56 + 죽은 공간 8.
const double kLabeledRemoveAdsMinWidth = 320.0 + 56.0 + 8.0;

/// "광고 제거" 진입 버튼. 상단바와 배너 왼쪽 여백에서 같은 위젯을 쓴다.
///
/// 무엇을 파는지 자세한 설명은 눌렀을 때 열리는 시트가 한다. 여기서는 자리가
/// 되면 짧은 라벨을, 안 되면 아이콘만 보여준다. 아이콘만인 경우에도 툴팁과
/// 스크린 리더용 라벨은 붙여 둔다.
class RemoveAdsButton extends StatelessWidget {
  const RemoveAdsButton({
    super.key,
    this.color,
    this.showLabel = false,
    this.maxLabelWidth = 88.0,
  });

  /// 화면을 조명으로 쓰는 동안에는 배경이 흰색이라 색을 넘겨받아야 한다.
  final Color? color;

  /// 아이콘 대신 짧은 라벨을 그릴지.
  final bool showLabel;

  /// 라벨이 차지할 수 있는 최대 폭.
  ///
  /// 언어마다 길이가 크게 다르다. 상한이 없으면 독일어처럼 긴 번역이 상단바를
  /// 밀어내거나 광고를 침범한다. 넘치면 말줄임표 대신 흐리게 흘린다.
  final double maxLabelWidth;

  @override
  Widget build(BuildContext context) {
    final FFLocalizations t = FFLocalizations.of(context);
    final String label = t.getTextOr('rmad0008' /* 광고 제거 */);
    final Color fg = color ?? FlutterFlowTheme.of(context).secondaryText;

    if (!showLabel) {
      return IconButton(
        onPressed: () => showRemoveAdsSheet(context),
        icon: const Icon(Icons.block),
        iconSize: 20.0,
        color: fg,
        tooltip: label,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 48.0, height: 48.0),
        visualDensity: VisualDensity.compact,
      );
    }

    return TextButton(
      onPressed: () => showRemoveAdsSheet(context),
      style: TextButton.styleFrom(
        foregroundColor: fg,
        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
        minimumSize: const Size(0.0, 40.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxLabelWidth),
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                color: fg,
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }
}

/// 광고가 아직 안 왔거나 끝내 못 띄웠을 때 그 빈자리에 그리는 제안.
///
/// 예전에는 로딩 중 배너 자리가 통째로 비어 있었다. 광고 하나 뜨는 데 시간이
/// 걸리는 동안 화면에 아무것도 없어서, 기다리다 앱을 닫는 일이 실제로 있었다.
/// 그 순간이야말로 "광고 없이 쓰기"를 제안하기 가장 좋은 때다.
class RemoveAdsInlinePromo extends StatelessWidget {
  const RemoveAdsInlinePromo({super.key});

  @override
  Widget build(BuildContext context) {
    final FFLocalizations t = FFLocalizations.of(context);
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    return ValueListenableBuilder<BillingReadiness>(
      valueListenable: billingReadiness,
      builder: (BuildContext context, BillingReadiness state, Widget? child) {
        // 가격은 반드시 Play 가 내려준 값을 쓴다. 하드코딩은 정책 위반이고
        // 나라마다 통화도 금액도 다르다. 아직 못 받았으면 그냥 비워 둔다.
        final String? price = state.product?.price;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => showRemoveAdsSheet(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      t.getTextOr('rmad0001' /* 광고 없이 사용하기 */),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodyMedium.override(
                        color: theme.primaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                  if (price != null) ...[
                    const SizedBox(width: 8.0),
                    Text(
                      price,
                      style: theme.bodyMedium.override(
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 구매와 복원을 담은 시트를 연다.
Future<void> showRemoveAdsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext sheetContext) => const _RemoveAdsSheet(),
  );
}

class _RemoveAdsSheet extends StatefulWidget {
  const _RemoveAdsSheet();

  @override
  State<_RemoveAdsSheet> createState() => _RemoveAdsSheetState();
}

class _RemoveAdsSheetState extends State<_RemoveAdsSheet> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // main() 이 이미 시작했지만 멱등하다. 상품 정보를 아직 못 받았을 수 있으니
    // 시트를 열 때 한 번 더 밀어준다.
    unawaited(ensureBillingReady());
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        // 권한이 생겼으면 시트를 닫는다. 홈 화면이 배너 자리를 통째로
        // 걷어내므로 시트만 남아 있을 이유가 없다.
        if (FFAppState().adsRemoved) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  /// 사용자에게 보여줄 결과 문구. 없으면 null.
  ///
  /// 성공(purchased/restored)은 여기서 다루지 않는다. 권한이 생기면 시트가
  /// 닫히므로 보여줄 자리가 없어진다.
  String? _message(BuildContext context, BillingOutcome outcome) {
    final FFLocalizations t = FFLocalizations.of(context);
    return switch (outcome) {
      BillingOutcome.pending =>
        t.getTextOr('rmad0004' /* 결제 승인을 기다리는 중입니다 */),
      BillingOutcome.failed =>
        t.getTextOr('rmad0005' /* 구매를 완료하지 못했습니다 */),
      BillingOutcome.notOwned =>
        t.getTextOr('rmad0006' /* 구매 내역이 없습니다 */),
      BillingOutcome.none ||
      BillingOutcome.purchased ||
      BillingOutcome.restored ||
      BillingOutcome.canceled =>
        null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final FFLocalizations t = FFLocalizations.of(context);
    final FlutterFlowTheme theme = FlutterFlowTheme.of(context);

    return SafeArea(
      child: ValueListenableBuilder<BillingReadiness>(
        valueListenable: billingReadiness,
        builder: (BuildContext context, BillingReadiness state, Widget? child) {
          final ProductDetails? product = state.product;
          final String? message = _message(context, state.outcome);
          // 상품 정보를 아직 못 받았어도 버튼은 살려 둔다. 눌렀을 때
          // buyRemoveAds() 가 준비를 기다렸다가 진행한다. 회색 버튼을 두고
          // 언제 켜지나 지켜보게 하는 것보다 낫다.
          final bool waiting = product == null;

          return Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t.getTextOr('rmad0001' /* 광고 없이 사용하기 */),
                  textAlign: TextAlign.center,
                  style: theme.headlineSmall.override(
                    color: theme.primaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  t.getTextOr('rmad0007' /* 한 번만 구매하면 광고가 영구히 사라집니다. */),
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium.override(
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                FilledButton(
                  onPressed: _busy ? null : () => _run(buyRemoveAds),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF38B6A8),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _busy
                      ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          waiting
                              ? t.getTextOr('rmad0002' /* 구매 */)
                              : '${t.getTextOr('rmad0002' /* 구매 */)}  ${product.price}',
                        ),
                ),
                const SizedBox(height: 4.0),
                TextButton(
                  onPressed: _busy ? null : () => _run(restoreRemoveAds),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.secondaryText,
                    minimumSize: const Size.fromHeight(44.0),
                  ),
                  child: Text(t.getTextOr('rmad0003' /* 구매 복원 */)),
                ),
                if (message != null) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.bodySmall.override(
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
