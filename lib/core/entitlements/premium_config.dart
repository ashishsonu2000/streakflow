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
  static const int freeHabitLimit = 20;

  /// Reminders per habit. Free keeps the original single daily
  /// reminder; Premium adds extra reminder times to the same habit.
  static const int freeRemindersPerHabit = 1;

  static const int premiumRemindersPerHabit = 5;

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

  /// While the app stays open, the subscription is re-verified with
  /// Google Play when the app returns to the foreground and the last
  /// successful check is at least this old (expiry, refund, cancel).
  static const Duration storeRecheckInterval = Duration(hours: 6);

  /// After returning from the Play purchase sheet, how long to wait for
  /// Play's purchase result before re-checking purchases directly.
  static const Duration purchaseResultWait = Duration(seconds: 4);
}
