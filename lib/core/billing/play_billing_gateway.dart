import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart'
    show PurchaseStateWrapper;
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../entitlements/premium_config.dart';
import '../utils/app_logger.dart';
import 'billing_gateway.dart';

// =====================================================================
// GOOGLE PLAY BILLING (Android)
//
// in_app_purchase + in_app_purchase_android (Google Play Billing
// Library 8). Maps Play subscription base plans to StorePlan and Play
// purchases to BillingPurchase. All decisions (grant, revoke,
// acknowledge) live in PremiumStoreNotifier.
//
// V1 sells each base plan's base offer (no promotional/trial offers).
// =====================================================================

class PlayBillingGateway implements BillingGateway {
  PlayBillingGateway({InAppPurchase? inAppPurchase})
      : _iap = inAppPurchase ?? InAppPurchase.instance;

  final InAppPurchase _iap;

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<List<StorePlan>> loadPlans() async {
    final response = await _iap.queryProductDetails(
      {PremiumConfig.subscriptionProductId},
    );

    if (response.error != null) {
      AppLogger.log('[Premium] Product query error: ${response.error!.code}');
    }

    if (response.notFoundIDs.isNotEmpty) {
      AppLogger.log(
        '[Premium] Not found in Play Console: ${response.notFoundIDs}',
      );
    }

    final plans = <StorePlan>[];

    for (final details
        in response.productDetails.whereType<GooglePlayProductDetails>()) {
      final index = details.subscriptionIndex;
      final offers = details.productDetails.subscriptionOfferDetails;

      if (index == null || offers == null || index >= offers.length) {
        continue;
      }

      final offer = offers[index];

      // Base offer only (promotional offers have an offerId).
      if (offer.offerId != null || offer.pricingPhases.isEmpty) {
        continue;
      }

      // The last phase is the recurring price.
      final recurring = offer.pricingPhases.last;

      plans.add(
        StorePlan(
          productId: details.id,
          basePlanId: offer.basePlanId,
          title: PlayBillingMapping.planTitle(offer.basePlanId),
          formattedPrice: recurring.formattedPrice,
          billingPeriodLabel:
              PlayBillingMapping.periodLabel(recurring.billingPeriod),
          handle: details,
        ),
      );
    }

    plans.sort(
      (a, b) => PlayBillingMapping.planOrder(a.basePlanId)
          .compareTo(PlayBillingMapping.planOrder(b.basePlanId)),
    );

    return plans;
  }

  @override
  Stream<List<BillingPurchase>> get purchaseUpdates =>
      _iap.purchaseStream.map((purchases) => purchases.map(_toBilling).toList());

  @override
  Future<void> buy(StorePlan plan) async {
    final details = plan.handle! as GooglePlayProductDetails;

    final launched = await _iap.buyNonConsumable(
      purchaseParam: GooglePlayPurchaseParam(
        productDetails: details,
        offerToken: details.offerToken,
      ),
    );

    if (!launched) {
      throw StateError('Google Play purchase flow was not launched');
    }
  }

  @override
  Future<List<BillingPurchase>?> queryOwnedPurchases() async {
    final addition =
        _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

    final response = await addition.queryPastPurchases();

    if (response.error != null) {
      AppLogger.log('[Premium] Purchase query error: ${response.error!.code}');
      return null;
    }

    return response.pastPurchases
        .map((p) => _toBilling(p, owned: true))
        .toList();
  }

  @override
  Future<void> complete(BillingPurchase purchase) async {
    await _iap.completePurchase(purchase.handle! as PurchaseDetails);
  }

  BillingPurchase _toBilling(PurchaseDetails details, {bool owned = false}) {
    var status = switch (details.status) {
      PurchaseStatus.pending => BillingPurchaseStatus.pending,
      PurchaseStatus.purchased =>
        owned ? BillingPurchaseStatus.restored : BillingPurchaseStatus.purchased,
      PurchaseStatus.restored => BillingPurchaseStatus.restored,
      PurchaseStatus.canceled => BillingPurchaseStatus.canceled,
      PurchaseStatus.error => BillingPurchaseStatus.error,
    };

    // Belt and braces: never treat a Play purchase as paid unless Play's
    // own purchase state says PURCHASED.
    if (details is GooglePlayPurchaseDetails &&
        (status == BillingPurchaseStatus.purchased ||
            status == BillingPurchaseStatus.restored) &&
        details.billingClientPurchase.purchaseState !=
            PurchaseStateWrapper.purchased) {
      status = BillingPurchaseStatus.pending;
    }

    return BillingPurchase(
      productId: details.productID,
      status: status,
      needsCompletion: details.pendingCompletePurchase,
      errorMessage: details.error?.message,
      handle: details,
    );
  }
}

/// Pure mapping helpers (unit tested).
abstract final class PlayBillingMapping {
  static String planTitle(String basePlanId) {
    if (basePlanId == PremiumConfig.monthlyBasePlanId) return 'Monthly';
    if (basePlanId == PremiumConfig.yearlyBasePlanId) return 'Yearly';
    if (basePlanId.isEmpty) return 'Premium';
    return basePlanId[0].toUpperCase() + basePlanId.substring(1);
  }

  /// Monthly first, then yearly, then anything else.
  static int planOrder(String basePlanId) {
    if (basePlanId == PremiumConfig.monthlyBasePlanId) return 0;
    if (basePlanId == PremiumConfig.yearlyBasePlanId) return 1;
    return 2;
  }

  /// ISO-8601 billing period (P1W, P1M, P3M, P1Y) → "per month" etc.
  static String periodLabel(String isoPeriod) {
    final match = RegExp(r'^P(\d+)([DWMY])$').firstMatch(isoPeriod);

    if (match == null) {
      return '';
    }

    final count = int.parse(match.group(1)!);
    final unit = switch (match.group(2)) {
      'D' => 'day',
      'W' => 'week',
      'M' => 'month',
      _ => 'year',
    };

    return count == 1 ? 'per $unit' : 'every $count ${unit}s';
  }
}
