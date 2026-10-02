import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/achievements/domain/enums/achievement_type.dart';
import 'package:streak_calculator_flutter/features/achievements/domain/services/achievement_builder.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/statistics_summary.dart';

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

  test('completion and XP achievements use all-time totals, not today',
      () {
    // Nothing done yet today, but plenty done before.
    final summary = testSummary();
    final overview = summary.overview.copyWith(
      totalCompletions: 0,
      totalXP: 0,
      lifetimeCompletions: 12,
      lifetimeXP: 120,
    );

    final achievements = builder.build(
      StatisticsSummary(
        overview: overview,
        weekly: summary.weekly,
        monthly: summary.monthly,
        yearly: summary.yearly,
        trends: summary.trends,
        performance: summary.performance,
        insights: summary.insights,
        logs: summary.logs,
        categoryDistribution: summary.categoryDistribution,
        xpTrend: summary.xpTrend,
      ),
    );
    bool unlocked(AchievementType type) =>
        achievements.firstWhere((a) => a.type == type).unlocked;

    // Previously: re-locked every morning / needed 10 completions or
    // 100 XP in a single day.
    expect(unlocked(AchievementType.firstCompletion), isTrue);
    expect(unlocked(AchievementType.completion10), isTrue);
    expect(unlocked(AchievementType.completion50), isFalse);
    expect(unlocked(AchievementType.xp100), isTrue);
    expect(unlocked(AchievementType.xp500), isFalse);
  });

  test('streak achievements stay unlocked after the streak breaks', () {
    final summary = testSummary();
    final overview = summary.overview.copyWith(
      currentStreak: 0,
      bestStreak: 8,
    );

    final achievements = builder.build(
      StatisticsSummary(
        overview: overview,
        weekly: summary.weekly,
        monthly: summary.monthly,
        yearly: summary.yearly,
        trends: summary.trends,
        performance: summary.performance,
        insights: summary.insights,
        logs: summary.logs,
        categoryDistribution: summary.categoryDistribution,
        xpTrend: summary.xpTrend,
      ),
    );
    bool unlocked(AchievementType type) =>
        achievements.firstWhere((a) => a.type == type).unlocked;

    expect(unlocked(AchievementType.streak3), isTrue);
    expect(unlocked(AchievementType.streak7), isTrue);
    expect(unlocked(AchievementType.streak30), isFalse);
  });
}
