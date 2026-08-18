import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'billing_util.dart';
import 'flutter_flow_theme.dart';
import 'internationalization.dart';

/// 배너 자리에 그리는 "광고 제거" 제안.
///
/// 이 앱에는 설정 화면이 없고 앱바도 비어 있어서, 구매와 **구매 복원**으로
/// 가는 유일한 통로가 여기다. 그래서 프로모 차례일 때뿐 아니라 광고를 끝내
/// 못 띄웠을 때도 이 위젯을 그린다(flutter_flow_ad_banner.dart 참고).
///
/// 배너 높이 안에 들어가야 하므로 두 줄로 끝낸다. 손전등 버튼 영역을
/// 밀어내면 안 된다.
class RemoveAdsPromo extends StatefulWidget {
  const RemoveAdsPromo({super.key});

  @override
  State<RemoveAdsPromo> createState() => _RemoveAdsPromoState();
}

class _RemoveAdsPromoState extends State<RemoveAdsPromo> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // main() 이 이미 시작했지만 멱등하다. 프로모가 먼저 그려지는 경우를 대비해
    // 여기서도 부른다 -- 상품 정보가 없으면 가격을 못 보여주기 때문이다.
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
      }
    }
  }

  /// 사용자에게 보여줄 결과 문구. 없으면 null.
  ///
  /// 성공(purchased/restored)은 여기서 다루지 않는다. 권한이 생기면 홈 화면이
  /// 이 위젯을 통째로 언마운트하므로 보여줄 자리가 없어진다.
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

    return ValueListenableBuilder<BillingReadiness>(
      valueListenable: billingReadiness,
      builder: (BuildContext context, BillingReadiness state, Widget? child) {
        final ProductDetails? product = state.product;
        // 가격은 반드시 Play 가 내려준 값을 쓴다. 하드코딩은 정책 위반이고,
        // 나라마다 통화도 금액도 다르다.
        final String? price = product?.price;
        final bool canBuy = product != null && !_busy;
        final String? message = _message(context, state.outcome);

        return Container(
          width: double.infinity,
          color: theme.primaryBackground,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
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
                    Text(
                      price,
                      style: theme.bodyMedium.override(
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                  TextButton(
                    onPressed: canBuy ? () => _run(buyRemoveAds) : null,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF38B6A8),
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      minimumSize: const Size(0.0, 32.0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    child: Text(t.getTextOr('rmad0002' /* 구매 */)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      message ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodySmall.override(
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _busy ? null : () => _run(restoreRemoveAds),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.secondaryText,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      minimumSize: const Size(0.0, 28.0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      t.getTextOr('rmad0003' /* 구매 복원 */),
                      style: theme.bodySmall.override(letterSpacing: 0.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
