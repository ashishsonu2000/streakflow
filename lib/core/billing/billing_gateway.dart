import 'package:flutter/foundation.dart';

import '../entitlements/premium_config.dart';

// =====================================================================
// BILLING GATEWAY
//
// Thin boundary between StreakFlow and the store (Google Play Billing on
// Android, the App Store on iOS). PremiumStoreNotifier depends only on
// this interface, so purchase/restore/entitlement rules are unit tested
// with a fake.
// =====================================================================

/// Store-specific wording for user-facing text. iOS must never mention
/// Google Play (App Review guideline 2.3.10), and vice versa.
@immutable
class StoreLabels {
  const StoreLabels._({
    required this.storeName,
    required this.accountName,
    required this.manageLocation,
    required this.manageSubscriptionsUrl,
  });

  static const googlePlay = StoreLabels._(
    storeName: 'Google Play',
    accountName: 'Google Play account',
    manageLocation: 'Google Play → Payments & subscriptions',
    manageSubscriptionsUrl:
        'https://play.google.com/store/account/subscriptions'
        '?sku=${PremiumConfig.subscriptionProductId}'
        '&package=com.codesapience.streakflow',
  );

  static const appStore = StoreLabels._(
    storeName: 'the App Store',
    accountName: 'Apple Account',
    manageLocation: 'Settings → your name → Subscriptions',
    manageSubscriptionsUrl: 'https://apps.apple.com/account/subscriptions',
  );

  static StoreLabels forPlatform(TargetPlatform platform) =>
      platform == TargetPlatform.iOS ? appStore : googlePlay;

  /// e.g. "Could not reach Google Play" / "Could not reach the App Store".
  final String storeName;

  /// The account payments are charged to and purchases belong to.
  final String accountName;

  /// Where the user manages or cancels the subscription.
  final String manageLocation;

  final String manageSubscriptionsUrl;
}

/// A purchasable Premium plan (a Google Play base plan, or an App Store
/// subscription product).
@immutable
class StorePlan {
  const StorePlan({
    required this.productId,
    required this.basePlanId,
    required this.title,
    required this.formattedPrice,
    required this.billingPeriodLabel,
    this.handle,
  });

  final String productId;
  final String basePlanId;

  /// e.g. "Monthly", "Yearly".
  final String title;

  /// Localized price from the store, e.g. "₹99.00".
  final String formattedPrice;

  /// e.g. "per month".
  final String billingPeriodLabel;

  /// Store-specific object needed to launch the purchase flow.
  final Object? handle;
}

enum BillingPurchaseStatus {
  /// Payment not yet completed (e.g. cash / UPI pending). Never grants.
  pending,

  /// Completed and paid.
  purchased,

  /// Previously purchased and still owned (restore / reinstall).
  restored,

  error,
  canceled,
}

@immutable
class BillingPurchase {
  const BillingPurchase({
    required this.productId,
    required this.status,
    this.needsCompletion = false,
    this.errorMessage,
    this.handle,
  });

  final String productId;
  final BillingPurchaseStatus status;

  /// Must be completed (acknowledged). Google Play refunds purchases
  /// that are not acknowledged within 3 days.
  final bool needsCompletion;

  final String? errorMessage;

  final Object? handle;

  bool get isActive =>
      status == BillingPurchaseStatus.purchased ||
      status == BillingPurchaseStatus.restored;
}

abstract interface class BillingGateway {
  /// False when the store can't be used (no Google Play, emulator
  /// without Play, unsupported platform).
  Future<bool> isAvailable();

  /// Premium plans configured in the store. Empty when the subscription
  /// has not been created / activated in Play Console yet.
  Future<List<StorePlan>> loadPlans();

  /// Purchase updates (new purchases, pending → purchased, errors).
  Stream<List<BillingPurchase>> get purchaseUpdates;

  /// Launches the store purchase flow. Results arrive on
  /// [purchaseUpdates].
  Future<void> buy(StorePlan plan);

  /// Purchases the store currently reports as owned. Returns null when
  /// the store could not be queried (offline, error) — callers must not
  /// revoke Premium in that case.
  Future<List<BillingPurchase>?> queryOwnedPurchases();

  /// Acknowledges / finishes a purchase with [BillingPurchase.needsCompletion].
  Future<void> complete(BillingPurchase purchase);

  /// Asks the store to refresh purchases from its servers before a
  /// user-initiated restore. The App Store may ask the user to sign in,
  /// so never call this automatically. No-op on Google Play.
  Future<void> syncPurchases();
}

/// Used where no store is available (non-Android platforms, tests).
class UnavailableBillingGateway implements BillingGateway {
  const UnavailableBillingGateway();

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<List<StorePlan>> loadPlans() async => const [];

  @override
  Stream<List<BillingPurchase>> get purchaseUpdates => const Stream.empty();

  @override
  Future<void> buy(StorePlan plan) async {}

  @override
  Future<List<BillingPurchase>?> queryOwnedPurchases() async => null;

  @override
  Future<void> complete(BillingPurchase purchase) async {}

  @override
  Future<void> syncPurchases() async {}
}
