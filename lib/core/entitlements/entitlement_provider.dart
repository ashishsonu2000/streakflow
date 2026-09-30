import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/shared_preferences_provider.dart';
import '../utils/app_logger.dart';
import 'entitlement_cache.dart';
import 'feature_access.dart';
import 'premium_config.dart';

// =====================================================================
// ENTITLEMENTS
//
// What the current user is entitled to. Features ask
// `ref.watch(featureAccessProvider)` (or `entitlementProvider` for the
// raw tier) and never know how the entitlement was obtained.
//
// Sources, in order:
//   1. Development override (debug/profile only):
//        --dart-define=DEV_ENTITLEMENT=premium
//      or the "Simulate premium" switch on the Ads Test page.
//   2. The last Premium entitlement verified by Google Play on this
//      device (EntitlementCache), valid for
//      PremiumConfig.offlineGracePeriod.
//   3. Free.
//
// Only the billing layer (lib/core/billing) may grant or revoke
// Premium, and only from Google Play purchase data. There is no other
// way to become Premium in a release build.
// =====================================================================

enum Entitlement {
  free,
  premium;

  bool get isPremium => this == Entitlement.premium;
}

/// Overridable clock for tests.
final entitlementClockProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});

final entitlementCacheProvider = Provider<EntitlementCache?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs == null ? null : EntitlementCache(prefs);
});

/// --dart-define=DEV_ENTITLEMENT=premium (ignored in release builds).
bool get _devPremium =>
    !kReleaseMode &&
    const String.fromEnvironment('DEV_ENTITLEMENT') == 'premium';

class EntitlementNotifier extends Notifier<Entitlement> {
  @override
  Entitlement build() {
    if (_devPremium) {
      return Entitlement.premium;
    }

    final record = ref.watch(entitlementCacheProvider)?.read();
    final now = ref.read(entitlementClockProvider)();

    if (record != null &&
        record.isValidAt(now, PremiumConfig.offlineGracePeriod)) {
      return Entitlement.premium;
    }

    return Entitlement.free;
  }

  /// Google Play reported an active, purchased (not pending) Premium
  /// subscription. Called only by the billing layer.
  Future<void> grantVerifiedPurchase({required String productId}) async {
    final now = ref.read(entitlementClockProvider)();

    await ref.read(entitlementCacheProvider)?.write(
          EntitlementRecord(productId: productId, verifiedAt: now),
        );

    if (state != Entitlement.premium) {
      AppLogger.log('[Premium] Entitlement granted ($productId)');
    }

    state = Entitlement.premium;
  }

  /// Google Play definitively reported no active Premium subscription
  /// (expired, cancelled after period end, refunded). Called only by
  /// the billing layer after a successful query — never on errors or
  /// while offline.
  Future<void> revokeAfterVerification() async {
    if (_devPremium) {
      return;
    }

    await ref.read(entitlementCacheProvider)?.clear();

    if (state == Entitlement.premium) {
      AppLogger.log('[Premium] Entitlement revoked (no active purchase)');
    }

    state = Entitlement.free;
  }

  /// Development-only toggle (Ads Test page). No effect in release.
  void debugOverride(Entitlement entitlement) {
    if (kReleaseMode) {
      return;
    }

    state = entitlement;
  }
}

final entitlementProvider =
    NotifierProvider<EntitlementNotifier, Entitlement>(
  EntitlementNotifier.new,
);

/// The single feature-access policy for the current user.
final featureAccessProvider = Provider<FeatureAccess>((ref) {
  return FeatureAccess(
    isPremium: ref.watch(entitlementProvider).isPremium,
  );
});
