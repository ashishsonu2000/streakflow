import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';

import '../entitlements/premium_config.dart';
import '../utils/app_logger.dart';
import 'billing_gateway.dart';
import 'play_billing_gateway.dart' show PlayBillingMapping;

// =====================================================================
// APP STORE (iOS)
//
// in_app_purchase + in_app_purchase_storekit (StoreKit 2, the plugin
// default). Maps the two App Store subscription products to StorePlan
// and StoreKit transactions to BillingPurchase. All decisions (grant,
// revoke, finish) live in PremiumStoreNotifier.
//
// Purchases of either Premium product are reported as
// PremiumConfig.subscriptionProductId, so the notifier's rules are the
// same on both stores.
//
// Known limitation: the plugin doesn't expose a transaction's
// revocationDate, so a refunded subscription keeps Premium until its
// current period ends (expirationDate).
//
// V1 sells each product's standard price (no introductory/promotional
// offers).
// =====================================================================

class AppStoreBillingGateway implements BillingGateway {
  AppStoreBillingGateway({
    InAppPurchase? inAppPurchase,
    DateTime Function()? now,
  })  : _iap = inAppPurchase ?? InAppPurchase.instance,
        _now = now ?? DateTime.now;

  final InAppPurchase _iap;
  final DateTime Function() _now;

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<List<StorePlan>> loadPlans() async {
    final response =
        await _iap.queryProductDetails(AppStoreBillingMapping.productIds);

    if (response.error != null) {
      AppLogger.log('[Premium] Product query error: ${response.error!.code}');
    }

    if (response.notFoundIDs.isNotEmpty) {
      AppLogger.log(
        '[Premium] Not found in App Store Connect: ${response.notFoundIDs}',
      );
    }

    final plans = <StorePlan>[];

    for (final details
        in response.productDetails.whereType<AppStoreProduct2Details>()) {
      final basePlanId = AppStoreBillingMapping.basePlanId(details.id);
      final subscription = details.sk2Product.subscription;

      if (basePlanId == null || subscription == null) {
        continue;
      }

      plans.add(
        StorePlan(
          productId: details.id,
          basePlanId: basePlanId,
          title: PlayBillingMapping.planTitle(basePlanId),
          // displayPrice: the standard price, localized by StoreKit.
          formattedPrice: details.price,
          billingPeriodLabel: PlayBillingMapping.periodLabel(
            AppStoreBillingMapping.isoPeriod(subscription.subscriptionPeriod),
          ),
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
    final launched = await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(
        productDetails: plan.handle! as AppStoreProduct2Details,
      ),
    );

    if (!launched) {
      throw StateError('App Store purchase flow was not launched');
    }
  }

  /// Reads the device's verified StoreKit transaction history
  /// (Transaction.all, kept in sync by iOS) and returns the Premium
  /// subscriptions that haven't expired.
  @override
  Future<List<BillingPurchase>?> queryOwnedPurchases() async {
    final List<SK2Transaction> transactions;

    try {
      transactions = await SK2Transaction.transactions();
    } catch (error) {
      AppLogger.log('[Premium] Transaction query error: $error');
      return null;
    }

    final now = _now();

    return transactions
        .where(
          (t) =>
              AppStoreBillingMapping.basePlanId(t.productId) != null &&
              AppStoreBillingMapping.isUnexpired(t.expirationDate, now),
        )
        .map(
          (t) => BillingPurchase(
            productId: PremiumConfig.subscriptionProductId,
            status: BillingPurchaseStatus.restored,
            // Unfinished transactions are re-delivered on
            // purchaseUpdates at launch and finished from there.
            needsCompletion: false,
            handle: t,
          ),
        )
        .toList();
  }

  @override
  Future<void> complete(BillingPurchase purchase) async {
    await _iap.completePurchase(purchase.handle! as PurchaseDetails);
  }

  /// AppStore.sync(): what Apple expects a Restore button to do. May
  /// show the Apple Account sign-in sheet.
  @override
  Future<void> syncPurchases() async {
    await _iap
        .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>()
        .sync();
  }

  BillingPurchase _toBilling(PurchaseDetails details) {
    var status = switch (details.status) {
      PurchaseStatus.pending => BillingPurchaseStatus.pending,
      PurchaseStatus.purchased => BillingPurchaseStatus.purchased,
      PurchaseStatus.restored => BillingPurchaseStatus.restored,
      PurchaseStatus.canceled => BillingPurchaseStatus.canceled,
      PurchaseStatus.error => BillingPurchaseStatus.error,
    };

    final isPremium =
        AppStoreBillingMapping.basePlanId(details.productID) != null;

    // Belt and braces: an old, already-expired transaction delivered
    // late (e.g. unfinished from a lapsed subscription) never grants.
    if (isPremium &&
        details is SK2PurchaseDetails &&
        (status == BillingPurchaseStatus.purchased ||
            status == BillingPurchaseStatus.restored) &&
        !AppStoreBillingMapping.isUnexpired(details.expirationDate, _now())) {
      status = BillingPurchaseStatus.canceled;
    }

    return BillingPurchase(
      productId:
          isPremium ? PremiumConfig.subscriptionProductId : details.productID,
      status: status,
      needsCompletion: details.pendingCompletePurchase,
      errorMessage: details.error?.message,
      handle: details,
    );
  }
}

/// Pure mapping helpers (unit tested).
abstract final class AppStoreBillingMapping {
  static const productIds = {
    PremiumConfig.appStoreMonthlyProductId,
    PremiumConfig.appStoreYearlyProductId,
  };

  /// App Store product → the equivalent Play base plan ID (used for plan
  /// titles, order and the paywall's default selection). Null for
  /// products that aren't Premium.
  static String? basePlanId(String productId) => switch (productId) {
        PremiumConfig.appStoreMonthlyProductId =>
          PremiumConfig.monthlyBasePlanId,
        PremiumConfig.appStoreYearlyProductId =>
          PremiumConfig.yearlyBasePlanId,
        _ => null,
      };

  /// StoreKit period → ISO-8601 (P1M), the format
  /// [PlayBillingMapping.periodLabel] reads.
  static String isoPeriod(SK2SubscriptionPeriod period) {
    final unit = switch (period.unit) {
      SK2SubscriptionPeriodUnit.day => 'D',
      SK2SubscriptionPeriodUnit.week => 'W',
      SK2SubscriptionPeriodUnit.month => 'M',
      SK2SubscriptionPeriodUnit.year => 'Y',
    };

    return 'P${period.value}$unit';
  }

  /// [expirationMillis]: milliseconds since epoch as a string, as the
  /// plugin reports it. Missing or unreadable → expired (never grants on
  /// data we can't check).
  static bool isUnexpired(String? expirationMillis, DateTime now) {
    final millis = int.tryParse(expirationMillis ?? '');

    if (millis == null) {
      return false;
    }

    return DateTime.fromMillisecondsSinceEpoch(millis).isAfter(now);
  }
}
