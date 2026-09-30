// Shared StatisticsSummary builder for tests.
import 'package:streak_calculator_flutter/features/statistics/domain/models/habit_performance.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/monthly_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/overview_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/statistics_summary.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekday_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekly_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekly_trend.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/yearly_statistics.dart';

/// Week of Mon 2026-09-28 … Sun 2026-10-04.
final testMonday = DateTime(2026, 9, 28);

WeekdayStatistics weekDay(int offset, {int done = 0, int target = 2}) {
  return WeekdayStatistics(
    date: testMonday.add(Duration(days: offset)),
    completedHabits: done,
    targetHabits: target,
    completionRate: target == 0 ? 0 : done / target,
    totalXP: done * 5,
    totalDurationMinutes: 0,
    isPerfectDay: target > 0 && done == target,
  );
}

StatisticsSummary testSummary({
  List<WeekdayStatistics>? days,
  double weekRate = 0,
  double lastWeekRate = 0,
  int totalTarget = 14,
  int currentStreak = 0,
  int perfectDaysThisMonth = 0,
  List<HabitPerformance> performance = const [],
}) {
  final weekDays = days ?? List.generate(7, (i) => weekDay(i));
  final best = weekDays
      .reduce((a, b) => b.completionRate > a.completionRate ? b : a);

  return StatisticsSummary(
    overview: OverviewStatistics(
      completionRate: weekRate,
      currentStreak: currentStreak,
      bestStreak: currentStreak,
      totalHabits: 2,
      totalCompletions: 10,
      totalXP: 50,
      totalDurationMinutes: 0,
      perfectDays: perfectDaysThisMonth,
    ),
    weekly: WeeklyStatistics(
      days: weekDays,
      completionRate: weekRate,
      previousWeekCompletionRate: lastWeekRate,
      weeklyChangePercentage: (weekRate - lastWeekRate) * 100,
      trend: WeeklyTrend.stable,
      totalCompleted: (weekRate * totalTarget).round(),
      totalTarget: totalTarget,
      totalXP: 40,
      totalDurationMinutes: 0,
      activeDays: weekDays.where((d) => d.completedHabits > 0).length,
      bestDay: best,
      worstDay: weekDays.first,
    ),
    monthly: MonthlyStatistics(
      monthlyCompletionRate: 0.5,
      totalCompleted: 20,
      totalXP: 100,
      totalDurationMinutes: 0,
      perfectDays: perfectDaysThisMonth,
      totalScheduled: 40,
      previousMonthCompletionRate: 0.4,
    ),
    yearly: const YearlyStatistics(
      year: 2026,
      completionRate: 0,
      totalScheduled: 0,
      totalCompleted: 0,
      totalMissed: 0,
      totalXP: 0,
      totalDurationMinutes: 0,
      perfectDays: 0,
      months: [],
    ),
    trends: const [],
    performance: performance,
    insights: const [],
    logs: const [],
    categoryDistribution: const [],
    xpTrend: const [],
  );
}
