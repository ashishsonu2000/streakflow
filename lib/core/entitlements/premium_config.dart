// =====================================================================
// STREAKFLOW PREMIUM — CENTRAL CONFIGURATION
//
// The single place for tier limits and Google Play product identifiers.
// Never repeat these values elsewhere in the codebase.
// =====================================================================

abstract final class PremiumConfig {
  /// Maximum number of ACTIVE (non-archived) habits on the Free plan.
  ///
  /// Existing habits above this number are never locked or hidden; the
  /// limit only blocks adding another active habit (create, duplicate,
  /// onboarding suggestion, unarchive).
  static const int freeHabitLimit = 5;

  // ---------------------------------------------------------------
  // Google Play Billing
  //
  // Must match Play Console → Monetize → Subscriptions exactly:
  //   subscription product: streakflow_premium
  //     base plan: monthly  (auto-renewing, 1 month)
  //     base plan: yearly   (auto-renewing, 1 year)
  // ---------------------------------------------------------------

  static const String subscriptionProductId = 'streakflow_premium';

  static const String monthlyBasePlanId = 'monthly';

  static const String yearlyBasePlanId = 'yearly';

  /// How long a Premium entitlement verified by Google Play stays valid
  /// on this device without re-verification (e.g. while offline).
  /// Verification is repeated on every app start when Play is reachable.
  static const Duration offlineGracePeriod = Duration(days: 7);
}
