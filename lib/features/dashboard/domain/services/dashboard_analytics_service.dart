import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/models/habit.dart';

import '../calculators/metrics_calculator.dart';
import '../calculators/streak_calculator.dart';
import '../calculators/xp_calculator.dart';
import '../models/dashboard_analytics.dart';

import '../calculators/heatmap_calculator.dart';
import '../calculators/weekly_progress_calculator.dart';
import '../calculators/activity_calculator.dart';

class DashboardAnalyticsService {
  const DashboardAnalyticsService();

  DashboardAnalytics calculate(
    List<Habit> habits,
    List<HabitLogEntity> logs,
  ) {
    //------------------------------------
    // Streak
    //------------------------------------

    final streak = StreakCalculator.calculate(
      logs,
    );

    //------------------------------------
    // XP
    //------------------------------------

    final totalXP = XPCalculator.calculateTotalXP(
      habits,
    );

    final level = XPCalculator.calculateLevel(
      totalXP,
    );

    final xpTarget = XPCalculator.calculateXPForNextLevel(
      level,
    );

    final achievement = XPCalculator.calculateAchievement(
      streak.currentStreak,
    );

    //------------------------------------
    // Metrics
    //------------------------------------

    final metrics = MetricsCalculator.calculate(
      habits,
      logs,
    );

    //------------------------------------
    // Weekly Progress
    //------------------------------------

    final weekly = WeeklyProgressCalculator.calculate(
      habits,
      logs,
    );

    //------------------------------------
    // Recent Activity
    //------------------------------------

    final activities = ActivityCalculator.calculate(logs);

    //------------------------------------
    // DashboardAnalytics
    //------------------------------------

    return DashboardAnalytics(
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      totalHabits: metrics.totalHabits,
      completedToday: metrics.completedToday,
      pendingToday: metrics.pendingToday,
      weeklyCompletion: metrics.weeklyCompletion,
      monthlyCompletion: metrics.monthlyCompletion,
      completionRate: metrics.completionRate,
      progress: metrics.progress,
      totalXp: totalXP,
      level: level,
      xpTarget: xpTarget,
      achievement: achievement,
      perfectDays: streak.perfectDays,
      completedDays: streak.completedDays,
      targetDays: metrics.totalHabits == 0 ? 0 : metrics.totalHabits * 30,
      weeklyProgress: weekly,
      recentActivity: activities,
      heatmap: HeatmapCalculator.calculate(logs),
    );
  }
}
