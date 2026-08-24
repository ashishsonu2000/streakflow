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

  final int currentStreak;

  final int bestStreak;

  final int totalCompleted;

  final int totalMissed;

  final int totalTrackedDays;

  final int activeDays;

  final int totalXP;

  /// 0.0 -> 1.0
  final double completionRate;

  /// 0.0 -> 100.0
  final double successRate;

  final double averagePerWeek;

  final int longestGap;
  final List<HabitDayStatistics> weeklyProgress;
  final List<HabitMonthStatistics> monthlyProgress;
  final List<HabitYearDayStatistics> yearlyProgress;
}
