import '../../../dashboard/domain/models/dashboard_analytics.dart';
import '../../../habits/domain/models/habit.dart';

import '../models/daily_statistics.dart';
import '../models/habit_statistics_summary.dart';
import '../models/statistics_summary.dart';

class StatisticsCalculator {
  const StatisticsCalculator._();

  static StatisticsSummary calculate(
    DashboardAnalytics analytics,
    List<Habit> habits,
  ) {
    final habitStats = habits
        .map(
          (habit) => HabitStatisticsSummary(
            habitId: habit.id,
            title: habit.title,
            currentStreak: habit.currentStreak,
            bestStreak: habit.bestStreak,
            totalCompleted: habit.totalCompleted,
            totalXP: habit.xp,
            completionRate: analytics.completedDays == 0
                ? 0
                : habit.totalCompleted / analytics.completedDays,
          ),
        )
        .toList()
      ..sort(
        (a, b) => b.completionRate.compareTo(a.completionRate),
      );

    final weekly = analytics.weeklyProgress
        .map(
          (day) => DailyStatistics(
            date: day.date,
            completedHabits: day.completedHabits,
            totalHabits: day.totalHabits,
          ),
        )
        .toList();

    return StatisticsSummary(
      dashboard: analytics,
      totalXP: analytics.totalXp,
      currentStreak: analytics.currentStreak,
      longestStreak: analytics.longestStreak,
      totalCompletions: analytics.completedDays,
      completionRate: analytics.completedPercentage,
      weekly: weekly,
      habits: habitStats,
      heatmap: analytics.heatmap,
    );
  }
}
