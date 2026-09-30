import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/achievements/domain/services/achievement_builder.dart';

import '../../support/statistics_summary_builder.dart';

void main() {
  const builder = AchievementBuilder();

  test('the 12 existing achievements are unchanged and free', () {
    final base =
        builder.build(testSummary()).where((a) => !a.isPremium).toList();

    expect(base, hasLength(12));
    expect(base.every((a) => !a.premiumLocked), isTrue);
  });

  test('free user: premium achievements listed, locked, never unlocked',
      () {
    final premium = builder
        .build(testSummary(currentStreak: 500))
        .where((a) => a.isPremium)
        .toList();

    expect(premium, hasLength(5));
    expect(premium.every((a) => a.premiumLocked), isTrue);
    expect(premium.every((a) => !a.unlocked), isTrue,
        reason: 'even when the target is met');
    expect(premium.every((a) => a.category == 'Premium'), isTrue);
  });

  test('premium user: advanced achievements unlock when targets are met',
      () {
    final premium = builder
        .build(testSummary(currentStreak: 120), premiumUnlocked: true)
        .where((a) => a.isPremium)
        .toList();

    final streak100 = premium.firstWhere((a) => a.title == 'Unstoppable');
    expect(streak100.premiumLocked, isFalse);
    expect(streak100.unlocked, isTrue);
    expect(streak100.progress, 1.0);

    final legend = premium.firstWhere((a) => a.title == 'Legend');
    expect(legend.unlocked, isFalse, reason: 'only 10 completions');
    expect(legend.progress, closeTo(10 / 500, 1e-9));
  });
}
