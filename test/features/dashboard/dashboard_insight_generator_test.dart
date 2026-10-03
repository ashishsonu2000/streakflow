import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/dashboard/domain/models/hero_view_model.dart';
import 'package:streak_calculator_flutter/features/dashboard/domain/services/dashboard_insight_generator.dart';

/// Nothing done yet today, out of 3 habits due.
HeroViewModel _hero({required int current, required int best}) {
  return HeroViewModel(
    currentStreak: current,
    bestStreak: best,
    totalXP: 0,
    level: 1,
    completedToday: 0,
    totalToday: 3,
    nextLevelXP: 100,
    xpProgress: 0,
    target: 3,
  );
}

String _getStarted(HeroViewModel hero) => const DashboardInsightGenerator()
    .generate(hero)
    .firstWhere((insight) => insight.title == 'Get Started')
    .message;

void main() {
  test('a brand-new user is told to begin a streak', () {
    expect(
      _getStarted(_hero(current: 0, best: 0)),
      'Complete your first habit today to begin your streak.',
    );
  });

  test('a running streak is to be kept going', () {
    expect(
      _getStarted(_hero(current: 5, best: 29)),
      'Complete a habit today to keep your 5-day streak going.',
    );
  });

  test('after a broken streak, start a new one', () {
    expect(
      _getStarted(_hero(current: 0, best: 29)),
      'Complete a habit today to start a new streak.',
    );
  });
}
