import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/ads/interstitial_policy.dart';

void main() {
  const policy = InterstitialPolicy(
    cooldown: Duration(minutes: 5),
    launchGracePeriod: Duration(minutes: 3),
    minMeaningfulActions: 6,
    maxPerSession: 2,
  );

  final sessionStart = DateTime(2026, 9, 29, 9);
  final later = sessionStart.add(const Duration(minutes: 30));

  InterstitialDecision evaluate({
    DateTime? now,
    DateTime? lastShownAt,
    int actions = 10,
    int shown = 0,
    bool premium = false,
    bool adsAvailable = true,
  }) {
    return policy.evaluate(
      now: now ?? later,
      sessionStartedAt: sessionStart,
      lastShownAt: lastShownAt,
      meaningfulActionsSinceLastShow: actions,
      shownThisSession: shown,
      isPremium: premium,
      adsAvailable: adsAvailable,
    );
  }

  test('allowed when every rule is satisfied', () {
    expect(evaluate(), InterstitialDecision.allowed);
  });

  test('premium always bypasses interstitials', () {
    expect(evaluate(premium: true), InterstitialDecision.premium);
  });

  test('not shown when ads are unavailable', () {
    expect(
      evaluate(adsAvailable: false),
      InterstitialDecision.adsUnavailable,
    );
  });

  test('never shown right after launch', () {
    expect(
      evaluate(now: sessionStart.add(const Duration(minutes: 1))),
      InterstitialDecision.launchGracePeriod,
    );
  });

  test('cooldown is respected', () {
    expect(
      evaluate(lastShownAt: later.subtract(const Duration(minutes: 4))),
      InterstitialDecision.cooldown,
    );
    expect(
      evaluate(lastShownAt: later.subtract(const Duration(minutes: 5))),
      InterstitialDecision.allowed,
    );
  });

  test('minimum meaningful actions are required', () {
    expect(evaluate(actions: 5), InterstitialDecision.notEnoughActions);
    expect(evaluate(actions: 6), InterstitialDecision.allowed);
  });

  test('per-session frequency limit is respected', () {
    expect(evaluate(shown: 2), InterstitialDecision.sessionLimitReached);
  });
}
