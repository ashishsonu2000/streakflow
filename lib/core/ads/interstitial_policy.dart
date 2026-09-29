import 'package:flutter/foundation.dart';

// =====================================================================
// INTERSTITIAL POLICY
//
// The only place that decides whether an interstitial may be shown.
// Deliberately conservative — Streak Flow is a habit tracker first:
//
//   • never for premium users
//   • never in the first [launchGracePeriod] of a session
//   • at least [cooldown] between two interstitials
//   • at least [minMeaningfulActions] since the last one
//   • at most [maxPerSession] per app session
//
// Callers must additionally only ask at a natural break (never right
// after habit completion/creation/deletion, never on tab navigation,
// never during onboarding or achievement celebrations).
// =====================================================================

enum InterstitialDecision {
  allowed,
  adsUnavailable,
  premium,
  launchGracePeriod,
  cooldown,
  notEnoughActions,
  sessionLimitReached,
}

@immutable
class InterstitialPolicy {
  const InterstitialPolicy({
    this.cooldown = const Duration(minutes: 5),
    this.launchGracePeriod = const Duration(minutes: 3),
    this.minMeaningfulActions = 6,
    this.maxPerSession = 2,
  });

  final Duration cooldown;
  final Duration launchGracePeriod;
  final int minMeaningfulActions;
  final int maxPerSession;

  InterstitialDecision evaluate({
    required DateTime now,
    required DateTime sessionStartedAt,
    required DateTime? lastShownAt,
    required int meaningfulActionsSinceLastShow,
    required int shownThisSession,
    required bool isPremium,
    required bool adsAvailable,
  }) {
    if (isPremium) {
      return InterstitialDecision.premium;
    }

    if (!adsAvailable) {
      return InterstitialDecision.adsUnavailable;
    }

    if (now.difference(sessionStartedAt) < launchGracePeriod) {
      return InterstitialDecision.launchGracePeriod;
    }

    if (shownThisSession >= maxPerSession) {
      return InterstitialDecision.sessionLimitReached;
    }

    if (lastShownAt != null && now.difference(lastShownAt) < cooldown) {
      return InterstitialDecision.cooldown;
    }

    if (meaningfulActionsSinceLastShow < minMeaningfulActions) {
      return InterstitialDecision.notEnoughActions;
    }

    return InterstitialDecision.allowed;
  }
}
