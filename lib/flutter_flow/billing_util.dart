import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_state.dart';
import 'home_widget_util.dart' show refreshHomeWidgets;

export 'package:in_app_purchase/in_app_purchase.dart' show ProductDetails;

// "광고 제거" 일회성 결제. 백엔드가 없으므로 권한은 기기에서 Play 에 직접
// 물어 판정한다. 구조는 admob_util.dart 를 그대로 따랐다 -- 모듈 레벨의
// 일회성 Future, 절대 예외를 던지지 않음, 그리고 사람이 읽을 수 있는 진단값.
//
// billingReadiness 는 두 곳에서 읽을 수 있다. 하나는 아래 debugPrint 로,
// emulator-check.yml 이 CI 에뮬레이터에서 logcat 을 받아오므로 여기 찍힌
// 값이 그대로 보인다(런타임 질문은 이쪽을 먼저 본다). 다른 하나는 위젯
// 트리에 그리는 것으로, 실기기에서만 나는 문제는 그 방법뿐이다 --
// 로컬에는 adb 가 없다(CLAUDE.md 의 `adb` 항목).

/// Play Console 에 등록한 상품 ID. 등록은 `.github/workflows/play-iap-create.yml`
/// 이 하고, 그 워크플로의 `PRODUCT_ID` 와 반드시 같아야 한다.
const String kRemoveAdsProductId = 'remove_ads';

/// 권한을 회수하기 전에 요구하는 "확정 미소유" 연속 횟수.
///
/// Play 는 현재 활성 계정 기준으로만 답한다. 사용자가 계정을 바꾸거나 Play
/// 스토어 앱이 잠깐 이상하면 실제로는 구매자인데 미소유로 나올 수 있다.
/// 한 번에 뺏으면 정상 구매자가 광고를 다시 보게 되므로, 서로 다른 콜드
/// 스타트에서 이만큼 연속으로 확정 미소유일 때만 회수한다.
const int _kRevokeAfterConsecutiveMisses = 3;

const String _kMissCountKey = '__remove_ads_miss_count__';

/// Play 결제 서비스 호출의 상한.
///
/// 이 상한이 없으면 결제 서비스가 없는 기기에서 앱이 조용히 멈춘다.
/// `BillingClientManager` 는 연결이 될 때까지 기다리는데, Play 스토어가
/// 아예 없으면 그 연결이 영영 안 된다. CI 에뮬레이터에서 실제로 그랬다 --
/// `isAvailable()` 에서 멈춰 `Billing readiness:` 진단조차 찍히지 않았다.
/// 그 상태로 사용자가 구매를 누르면 스피너만 계속 돈다.
const Duration _kBillingTimeout = Duration(seconds: 20);

/// 마지막 결제 동작의 결과. 프로모가 사용자에게 보여줄 문구를 고르는 데 쓴다.
enum BillingOutcome {
  /// 아직 아무 일도 없었다.
  none,

  /// 구매가 끝났고 권한을 줬다.
  purchased,

  /// 결제 승인 대기 중. 가상계좌·무통장·편의점 결제가 이 경로다.
  /// **권한을 주면 안 된다.**
  pending,

  /// 사용자가 결제창을 닫았다.
  canceled,

  /// 구매를 완료하지 못했다.
  failed,

  /// 복원으로 권한을 되찾았다.
  restored,

  /// 복원했는데 살 것이 없었다.
  notOwned,
}

/// 결제 준비 과정에서 어디까지 갔는지를 담는다.
@immutable
class BillingReadiness {
  const BillingReadiness({
    required this.available,
    required this.query,
    required this.product,
    required this.outcome,
    this.error,
  });

  /// Play 결제 서비스에 붙었는지.
  final bool available;

  /// 마지막 소유 조회의 결과를 사람이 읽을 수 있게 적은 것.
  final String query;

  /// 상품 정보. 가격 표시에 쓴다. null 이면 아직 못 받았다는 뜻이고,
  /// 이때는 구매 버튼을 눌러도 소용없으므로 비활성화해야 한다.
  final ProductDetails? product;

  /// 마지막 결제 동작의 결과.
  final BillingOutcome outcome;

  /// 준비 과정에서 난 예외.
  final String? error;

  BillingReadiness copyWith({
    bool? available,
    String? query,
    ProductDetails? product,
    BillingOutcome? outcome,
    String? error,
  }) =>
      BillingReadiness(
        available: available ?? this.available,
        query: query ?? this.query,
        product: product ?? this.product,
        outcome: outcome ?? this.outcome,
        error: error ?? this.error,
      );

  String describe() => [
        '결제 서비스: ${available ? '연결됨' : '연결 안 됨'}',
        '소유 조회: $query',
        '상품: ${product == null ? '못 받음' : '${product!.id} ${product!.price}'}',
        '마지막 결과: ${outcome.name}',
        if (error != null) '오류: $error',
      ].join('\n');
}

const BillingReadiness _pending = BillingReadiness(
  available: false,
  query: '확인 전',
  product: null,
  outcome: BillingOutcome.none,
);

/// 결제 상태. 프로모 위젯이 이걸 듣고 다시 그린다.
///
/// 권한 자체(광고를 지울지)는 여기가 아니라 `FFAppState().adsRemoved` 에 있다.
/// 앱 전역 상태는 FFAppState 에 두는 것이 이 저장소의 방식이고, 홈 화면이
/// 이미 `context.watch<FFAppState>()` 로 그걸 듣고 있기 때문이다.
final ValueNotifier<BillingReadiness> billingReadiness =
    ValueNotifier<BillingReadiness>(_pending);

Future<void>? _ready;
SharedPreferences? _prefs;
StreamSubscription<List<PurchaseDetails>>? _subscription;

/// 결제 초기화를 한 번만 수행하고, 끝나면 완료되는 Future.
///
/// 절대 예외를 던지지 않는다. Play 가 없든 네트워크가 없든 손전등은 그대로
/// 동작해야 하므로 main() 은 이걸 기다리지 않는다.
Future<void> ensureBillingReady() {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    return Future<void>.value();
  }
  return _ready ??= _prepareBilling();
}

Future<void> _prepareBilling() async {
  try {
    _prefs = await SharedPreferences.getInstance();

    // purchaseStream 은 앱이 뜨자마자 구독해야 한다. 지난 세션에서 끝내지
    // 못한 구매(예: 승인 전에 앱이 죽은 경우)가 새 세션 시작 시 여기로 다시
    // 들어오는데, 구독이 없으면 그 이벤트를 통째로 놓친다.
    //
    // InAppPurchase.instance 를 만지는 순간 Android 플랫폼이 등록된다.
    // 아래에서 InAppPurchasePlatform.instance 를 캐스팅하려면 그 등록이
    // 먼저 끝나 있어야 하므로 순서를 바꾸지 마라.
    _subscription ??= InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdates,
      onError: (Object e) => _update(error: '구매 스트림: $e'),
    );

    final bool available = await InAppPurchase.instance
        .isAvailable()
        .timeout(_kBillingTimeout, onTimeout: () => false);
    _update(available: available);

    if (available) {
      await _loadProduct();
      await refreshEntitlement();
    } else {
      // 연결이 안 된 상태에서 상품 조회나 소유 조회를 부르면 같은 연결을
      // 기다리다 똑같이 멈춘다. 여기서 끝낸다.
      _update(query: '결제 서비스에 연결할 수 없음');
    }
  } catch (e) {
    _update(error: '초기화: $e');
  }
  debugPrint('Billing readiness:\n${billingReadiness.value.describe()}');
}

Future<void> _loadProduct() async {
  try {
    final ProductDetailsResponse response = await InAppPurchase.instance
        .queryProductDetails(<String>{kRemoveAdsProductId}).timeout(_kBillingTimeout);
    final List<ProductDetails> matches = response.productDetails
        .where((ProductDetails p) => p.id == kRemoveAdsProductId)
        .toList();
    if (matches.isNotEmpty) {
      _update(product: matches.first);
    } else {
      _update(
        error: response.error != null
            ? '상품 조회: ${response.error!.message}'
            : '상품 없음(미등록 또는 비활성)',
      );
    }
  } catch (e) {
    _update(error: '상품 조회: $e');
  }
}

/// Play 에 직접 물어 소유 여부를 다시 판정한다.
///
/// **`InAppPurchase.restorePurchases()` 나 `queryPastPurchases()` 로는 이걸
/// 할 수 없다.** 둘 다 내부에서 `queryPurchases` 를 `forceOkResponseCode: true`
/// 로 부르고(`billing_client_wrapper.dart`), 변환기가 `responseCode` 를 `ok`
/// 로 덮어써버린다(`pigeon_converters.dart`). 그래서 두 API 의 오류 감지는
/// 항상 빈 집합을 보고 죽어 있고, `networkError` 나 `serviceUnavailable` 을
/// 절대 알려주지 못한다. "안 샀다"와 "Play 에 못 물어봤다"를 구분하지 못하면
/// 정상 구매자의 권한을 뺏게 되므로, 플러그인이 이미 들고 있는 매니저를
/// 빌려 `billingResult.responseCode` 를 직접 읽는다.
///
/// 두 번째 `BillingClientManager` 를 새로 만들면 안 된다. 생성자가 고정된
/// pigeon 채널에 `setMessageHandler` 를 거는데 이는 교체이지 추가가 아니라서,
/// 나중에 만든 쪽이 채널을 가로채고 먼저 것의 `purchaseStream` 이 영구히
/// 죽는다. 그러면 구매해도 이벤트가 안 오고, 승인을 못 해서 3일 뒤 자동
/// 환불된다. 같은 이유로 이 매니저에 `dispose()` 를 부르면 절대 안 된다 --
/// 플러그인과 공유하는 클라이언트를 끊는다.
///
/// [countMisses] 가 false 면 회수 판정을 하지 않는다. 사용자가 "구매 복원"을
/// 누른 경우가 그렇다. 회수는 콜드 스타트에서만 센다.
Future<void> refreshEntitlement({bool countMisses = true}) async {
  final platform = InAppPurchasePlatform.instance;
  if (platform is! InAppPurchaseAndroidPlatform) {
    return;
  }

  try {
    // ignore: invalid_use_of_visible_for_testing_member
    final BillingClientManager manager = platform.billingClientManager;

    final PurchasesResultWrapper result = await manager
        .runWithClient(
          (BillingClient client) => client.queryPurchases(ProductType.inapp),
        )
        .timeout(_kBillingTimeout);

    // result.responseCode 가 아니다. 그 필드는 항상 ok 로 강제돼 있다.
    final BillingResponse code = result.billingResult.responseCode;

    if (code != BillingResponse.ok) {
      // Play 에 못 물어봤다. 마지막 판정을 그대로 두고 카운터도 건드리지 않는다.
      _update(query: '조회 실패(${code.name}) - 이전 판정 유지');
      return;
    }

    final Iterable<PurchaseWrapper> mine = result.purchasesList.where(
      // productID 가 아니라 products 다. PurchaseWrapper 쪽은 List<String>.
      (PurchaseWrapper p) => p.products.contains(kRemoveAdsProductId),
    );

    // pending 을 소유로 세면 안 된다. 한국의 가상계좌·무통장·편의점 결제가
    // 이 상태로 며칠 머무를 수 있고, 그동안 돈은 들어오지 않는다.
    final bool owned = mine.any(
      (PurchaseWrapper p) => p.purchaseState == PurchaseStateWrapper.purchased,
    );

    // 승인이 빠지면 Play 가 자동 환불한다(프로덕션 3일, 라이선스 테스터 3분).
    // purchaseStream 쪽에서도 승인하지만, 그 이벤트를 놓친 구매가 여기서 잡힌다.
    for (final PurchaseWrapper p in mine) {
      if (p.purchaseState == PurchaseStateWrapper.purchased && !p.isAcknowledged) {
        await manager.runWithClient(
          (BillingClient client) => client.acknowledgePurchase(p.purchaseToken),
        );
      }
    }

    _update(query: owned ? '소유 확인' : '확정 미소유');

    if (owned) {
      _setEntitlement(true);
      _prefs?.setInt(_kMissCountKey, 0);
    } else if (countMisses && FFAppState().adsRemoved) {
      final int misses = (_prefs?.getInt(_kMissCountKey) ?? 0) + 1;
      if (misses >= _kRevokeAfterConsecutiveMisses) {
        _prefs?.setInt(_kMissCountKey, 0);
        _setEntitlement(false);
      } else {
        _prefs?.setInt(_kMissCountKey, misses);
        _update(query: '확정 미소유 $misses/$_kRevokeAfterConsecutiveMisses회');
      }
    }
  } catch (e) {
    _update(error: '소유 조회: $e');
  }
}

void _onPurchaseUpdates(List<PurchaseDetails> purchases) {
  for (final PurchaseDetails details in purchases) {
    if (details.productID != kRemoveAdsProductId) {
      continue;
    }
    unawaited(_handlePurchase(details));
  }
}

Future<void> _handlePurchase(PurchaseDetails details) async {
  try {
    if (details.status == PurchaseStatus.pending) {
      // 아직 돈이 들어오지 않았다. 권한을 주지 않는다.
      _update(outcome: BillingOutcome.pending);
    } else if (details.status == PurchaseStatus.purchased ||
        details.status == PurchaseStatus.restored) {
      _setEntitlement(true);
      _prefs?.setInt(_kMissCountKey, 0);
      _update(
        outcome: details.status == PurchaseStatus.purchased
            ? BillingOutcome.purchased
            : BillingOutcome.restored,
      );
    } else if (details.status == PurchaseStatus.canceled) {
      _update(outcome: BillingOutcome.canceled);
    } else {
      _update(
        outcome: BillingOutcome.failed,
        error: '구매: ${details.error?.message ?? '알 수 없는 오류'}',
      );
    }

    // completePurchase 에는 pending 가드가 없고, Android 의
    // pendingCompletePurchase 는 `!isAcknowledged` 라서 pending 에서도 true 다.
    // 가드 없이 부르면 pending 구매를 완료 처리하려다 예외가 난다.
    if (details.pendingCompletePurchase &&
        (details.status == PurchaseStatus.purchased ||
            details.status == PurchaseStatus.restored)) {
      await InAppPurchase.instance.completePurchase(details);
    }
  } catch (e) {
    _update(error: '구매 처리: $e');
  }
}

/// 구매 흐름을 띄운다. 결과는 [billingReadiness] 로 온다.
Future<void> buyRemoveAds() async {
  // 상품 정보를 아직 못 받았을 수 있다. 회색 버튼을 두고 언제 켜지나 지켜보게
  // 하는 대신, 눌렀을 때 여기서 기다린다. main() 이 이미 시작해 뒀으므로
  // 대개는 즉시 끝나고, 네트워크가 느렸던 경우에만 실제로 기다린다.
  await ensureBillingReady();

  if (!billingReadiness.value.available) {
    // Play 결제 서비스에 붙지 못한 기기다. 여기서 상품을 다시 조회해봐야
    // 같은 연결을 기다릴 뿐이므로 곧장 실패로 알린다. 스피너를 20초 더
    // 돌리는 것보다 낫다.
    _update(outcome: BillingOutcome.failed, error: '결제 서비스에 연결할 수 없음');
    return;
  }

  if (billingReadiness.value.product == null) {
    // 시작할 때 조회가 실패했을 수 있다. 한 번 더 해본다.
    await _loadProduct();
  }

  final ProductDetails? product = billingReadiness.value.product;
  if (product == null) {
    _update(outcome: BillingOutcome.failed, error: '상품 정보 없음');
    return;
  }
  try {
    final bool started = await InAppPurchase.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
    if (!started) {
      // 이미 소유 중이면 여기로 온다. 그건 오류가 아니라 권한을 줘야 하는
      // 상황이므로, 실패로 단정하기 전에 소유 여부를 다시 확인한다.
      await refreshEntitlement(countMisses: false);
      if (!FFAppState().adsRemoved) {
        _update(outcome: BillingOutcome.failed);
      }
    }
  } catch (e) {
    _update(outcome: BillingOutcome.failed, error: '구매 시작: $e');
  }
}

/// 기기 교체·재설치·계정 전환 뒤에 권한을 되찾는다.
Future<void> restoreRemoveAds() async {
  await refreshEntitlement(countMisses: false);
  if (!FFAppState().adsRemoved) {
    _update(outcome: BillingOutcome.notOwned);
  } else {
    _update(outcome: BillingOutcome.restored);
  }
}

void _setEntitlement(bool value) {
  // FFAppState() 는 매번 새로 부른다. reset() 이 싱글턴 인스턴스를 통째로
  // 갈아치우므로 참조를 들고 있으면 죽은 객체를 갱신하게 된다.
  if (FFAppState().adsRemoved == value) {
    return;
  }
  FFAppState().update(() {
    FFAppState().adsRemoved = value;
  });
  // 홈 화면 위젯은 이 값을 shared_preferences 에서 직접 읽어 잠금을 푼다.
  // 값이 바뀌었으니 다시 그리게 한다. 구매 직후 홈으로 나갔을 때 위젯이
  // 여전히 잠겨 있으면 산 것이 맞나 의심하게 된다.
  unawaited(refreshHomeWidgets());
}

void _update({
  bool? available,
  String? query,
  ProductDetails? product,
  BillingOutcome? outcome,
  String? error,
}) {
  billingReadiness.value = billingReadiness.value.copyWith(
    available: available,
    query: query,
    product: product,
    outcome: outcome,
    error: error,
  );
}
