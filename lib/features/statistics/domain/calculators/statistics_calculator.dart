import '../../../dashboard/domain/models/dashboard_analytics.dart';
import '../../../habits/domain/models/habit.dart';

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

    final heatmapMap = {
      for (final day in analytics.heatmap) day.date: day.count
    };

    return StatisticsSummary(
      dashboard: analytics,
      totalXP: analytics.levelSummary.totalXp,
      currentStreak: analytics.currentStreak,
      longestStreak: analytics.longestStreak,
      totalCompletions: analytics.completedDays,
      completionRate: analytics.completionRate,
      weekly: analytics.weekly,
      habits: habitStats,
      heatmap: heatmapMap,
    );
  }
}
