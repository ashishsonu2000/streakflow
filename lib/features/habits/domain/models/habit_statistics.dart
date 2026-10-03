import 'package:flutter/foundation.dart';

import 'habit_day_statistics.dart';
import 'habit_month_statistics.dart';
import 'habit_year_day_statistics.dart';

@immutable
class HabitStatistics {
  const HabitStatistics({
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompleted,
    required this.totalMissed,
    required this.totalTrackedDays,
    required this.activeDays,
    required this.totalXP,
    required this.completionRate,
    required this.successRate,
    required this.averagePerWeek,
    required this.longestGap,
    required this.weeklyProgress,
    required this.monthlyProgress,
    required this.yearlyProgress,
  });

  // ===========================================================
  // STREAK
  // ===========================================================

  final int currentStreak;

  final int bestStreak;

  // ===========================================================
  // ACTIVITY
  // ===========================================================

  final int totalCompleted;

  final int totalMissed;

  final int totalTrackedDays;

  final int activeDays;

  // ===========================================================
  // XP
  // ===========================================================

  final int totalXP;

  // ===========================================================
  // RATES
  // ===========================================================

  /// Completion percentage.
  ///
  /// Range:
  ///
  /// 0.0 -> 100.0
  final double completionRate;

  /// Success percentage.
  ///
  /// Range:
  ///
  /// 0.0 -> 100.0
  final double successRate;

  // ===========================================================
  // PERFORMANCE
  // ===========================================================

  final double averagePerWeek;

  final int longestGap;

  // ===========================================================
  // PERIOD STATISTICS
  // ===========================================================

  /// Seven days representing the current week.
  ///
  /// Each day contains:
  ///
  /// - date
  /// - completed
  /// - isWithinHabitRange
  final List<HabitDayStatistics> weeklyProgress;

  /// Days representing the selected month.
  final List<HabitMonthStatistics> monthlyProgress;

  /// Days representing the selected year.
  final List<HabitYearDayStatistics> yearlyProgress;
}