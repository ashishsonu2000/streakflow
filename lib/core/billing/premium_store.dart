import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entitlements/entitlement_provider.dart';
import '../entitlements/premium_config.dart';
import '../utils/app_logger.dart';
import 'billing_gateway.dart';
import 'play_billing_gateway.dart';

// =====================================================================
// PREMIUM STORE
//
// Orchestrates Google Play Billing for StreakFlow Premium:
//   • startup reconciliation (restore on reinstall, detect expiry)
//   • purchase, pending, success, cancel, error
//   • restore purchases
//   • acknowledging purchases (Play refunds unacknowledged ones)
//
// It is the ONLY code that grants or revokes Premium, and only from
// Google Play purchase data:
//   purchased / restored  → grant
//   pending               → never grants
//   query succeeded, no active purchase → revoke
//   query failed (offline) → keep the cached entitlement
// =====================================================================

enum PremiumStoreStatus { loading, unavailable, ready }

@immutable
class PremiumStoreState {
  const PremiumStoreState({
    this.status = PremiumStoreStatus.loading,
    this.plans = const [],
    this.purchaseInProgress = false,
    this.purchasePending = false,
    this.message,
  });

  final PremiumStoreStatus status;
  final List<StorePlan> plans;

  /// The Google Play purchase sheet is open / a restore is running.
  final bool purchaseInProgress;

  /// A purchase is waiting for payment (e.g. cash, UPI).
  final bool purchasePending;

  /// Latest user-facing result or error. Null when nothing to show.
  final String? message;

  bool get canPurchase =>
      status == PremiumStoreStatus.ready &&
      plans.isNotEmpty &&
      !purchaseInProgress;

  PremiumStoreState copyWith({
    PremiumStoreStatus? status,
    List<StorePlan>? plans,
    bool? purchaseInProgress,
    bool? purchasePending,
    String? message,
    bool clearMessage = false,
  }) {
    return PremiumStoreState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      purchaseInProgress: purchaseInProgress ?? this.purchaseInProgress,
      purchasePending: purchasePending ?? this.purchasePending,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

/// Google Play Billing on Android; unavailable elsewhere (iOS App Store
/// subscriptions are not part of this release).
final billingGatewayProvider = Provider<BillingGateway>((ref) {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return PlayBillingGateway();
  }

  return const UnavailableBillingGateway();
});

class PremiumStoreNotifier extends Notifier<PremiumStoreState> {
  StreamSubscription<List<BillingPurchase>>? _subscription;
  Future<void>? _initialization;

  BillingGateway get _gateway => ref.read(billingGatewayProvider);

  @override
  PremiumStoreState build() {
    ref.onDispose(() => _subscription?.cancel());
    return const PremiumStoreState();
  }

  /// Connects to the store, reconciles the entitlement with Google Play
  /// and loads plans. Safe to call repeatedly; runs once.
  Future<void> initialize() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    try {
      if (!await _gateway.isAvailable()) {
        AppLogger.log('[Premium] Store unavailable');
        state = state.copyWith(
          status: PremiumStoreStatus.unavailable,
          message: 'Google Play Billing is not available on this device.',
        );
        return;
      }

      _subscription = _gateway.purchaseUpdates.listen(
        _onPurchaseUpdates,
        onError: (Object error) {
          AppLogger.log('[Premium] Purchase stream error: $error');
        },
      );

      await _reconcileWithStore();

      final plans = await _gateway.loadPlans();
      AppLogger.log('[Premium] Plans loaded: ${plans.length}');

      state = state.copyWith(
        status: plans.isEmpty
            ? PremiumStoreStatus.unavailable
            : PremiumStoreStatus.ready,
        plans: plans,
        message: plans.isEmpty
            ? 'StreakFlow Premium is not available yet. Please check '
                'again later.'
            : null,
        clearMessage: plans.isNotEmpty,
      );
    } catch (error) {
      AppLogger.log('[Premium] Store initialization failed: $error');
      state = state.copyWith(
        status: PremiumStoreStatus.unavailable,
        message: 'Could not connect to Google Play. Please try again.',
      );
    }
  }

  // ===================================================================
  // PURCHASE
  // ===================================================================

  Future<void> buy(StorePlan plan) async {
    if (!state.canPurchase) {
      return;
    }

    state = state.copyWith(purchaseInProgress: true, clearMessage: true);

    try {
      await _gateway.buy(plan);
      // The result arrives on the purchase stream.
    } catch (error) {
      AppLogger.log('[Premium] Purchase launch failed: $error');
      state = state.copyWith(
        purchaseInProgress: false,
        message: 'The purchase could not be started. Please try again.',
      );
    }
  }

  // ===================================================================
  // RESTORE
  // ===================================================================

  /// Returns true when an active Premium subscription was found.
  Future<bool> restore() async {
    if (state.purchaseInProgress) {
      return false;
    }

    state = state.copyWith(purchaseInProgress: true, clearMessage: true);

    final found = await _reconcileWithStore();

    state = state.copyWith(
      purchaseInProgress: false,
      message: switch (found) {
        true => 'Your StreakFlow Premium subscription has been restored.',
        false => 'No active StreakFlow Premium subscription was found '
            'for this Google account.',
        null => 'Could not reach Google Play. Check your connection and '
            'try again.',
      },
    );

    return found ?? false;
  }

  void clearMessage() => state = state.copyWith(clearMessage: true);

  // ===================================================================
  // RECONCILIATION
  // ===================================================================

  /// true = active Premium found, false = definitely none,
  /// null = store could not be queried (entitlement left unchanged).
  Future<bool?> _reconcileWithStore() async {
    final owned = await _gateway.queryOwnedPurchases();

    if (owned == null) {
      AppLogger.log('[Premium] Could not query purchases; keeping cache');
      return null;
    }

    final premium = owned
        .where((p) => p.productId == PremiumConfig.subscriptionProductId)
        .toList();

    await _completeIfNeeded(premium);

    final entitlement = ref.read(entitlementProvider.notifier);

    if (premium.any((p) => p.isActive)) {
      await entitlement.grantVerifiedPurchase(
        productId: PremiumConfig.subscriptionProductId,
      );
      state = state.copyWith(purchasePending: false);
      return true;
    }

    await entitlement.revokeAfterVerification();
    state = state.copyWith(
      purchasePending:
          premium.any((p) => p.status == BillingPurchaseStatus.pending),
    );
    return false;
  }

  Future<void> _onPurchaseUpdates(List<BillingPurchase> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productId != PremiumConfig.subscriptionProductId) {
        // Not ours; still finish it so Play doesn't keep re-delivering.
        await _completeIfNeeded([purchase]);
        continue;
      }

      switch (purchase.status) {
        case BillingPurchaseStatus.pending:
          AppLogger.log('[Premium] Purchase pending');
          state = state.copyWith(
            purchaseInProgress: false,
            purchasePending: true,
            message: 'Your payment is pending. Premium unlocks as soon '
                'as Google Play confirms it.',
          );

        case BillingPurchaseStatus.purchased:
        case BillingPurchaseStatus.restored:
          AppLogger.log('[Premium] Purchase ${purchase.status.name}');
          await ref
              .read(entitlementProvider.notifier)
              .grantVerifiedPurchase(productId: purchase.productId);
          await _completeIfNeeded([purchase]);
          state = state.copyWith(
            purchaseInProgress: false,
            purchasePending: false,
            message: purchase.status == BillingPurchaseStatus.purchased
                ? 'Welcome to StreakFlow Premium!'
                : null,
          );

        case BillingPurchaseStatus.canceled:
          AppLogger.log('[Premium] Purchase canceled');
          await _completeIfNeeded([purchase]);
          state = state.copyWith(
            purchaseInProgress: false,
            clearMessage: true,
          );

        case BillingPurchaseStatus.error:
          AppLogger.log('[Premium] Purchase error: ${purchase.errorMessage}');
          await _completeIfNeeded([purchase]);
          state = state.copyWith(
            purchaseInProgress: false,
            message: 'The purchase did not complete. You have not been '
                'charged for Premium. Please try again.',
          );
      }
    }
  }

  Future<void> _completeIfNeeded(List<BillingPurchase> purchases) async {
    for (final purchase in purchases) {
      if (!purchase.needsCompletion ||
          purchase.status == BillingPurchaseStatus.pending) {
        continue;
      }

      try {
        await _gateway.complete(purchase);
        AppLogger.log('[Premium] Purchase acknowledged');
      } catch (error) {
        // Retried on the next start via reconciliation.
        AppLogger.log('[Premium] Acknowledge failed: $error');
      }
    }
  }
}

final premiumStoreProvider =
    NotifierProvider<PremiumStoreNotifier, PremiumStoreState>(
  PremiumStoreNotifier.new,
);
