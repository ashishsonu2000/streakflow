import 'package:flutter/material.dart';

import '../../../../core/progression/calculators/level_calculator.dart';
import '../../../calendar/domain/models/calendar_view_model.dart';
import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/calculators/activity_calculator.dart';
import '../../../habits/domain/calculators/heatmap_calculator.dart';
import '../../../habits/domain/calculators/metrics/metrics_calculator.dart';
import '../../../habits/domain/calculators/streak_calculator.dart';
import '../../../habits/domain/calculators/weekly_progress_calculator.dart';
import '../../../habits/domain/models/habit.dart';

import '../builders/analytics_card_builder.dart';
import '../models/dashboard_analytics.dart';

class DashboardAnalyticsService {
  DashboardAnalyticsService({
    LevelCalculator? levelCalculator,
  }) : _levelCalculator = levelCalculator ?? const LevelCalculator();

  final LevelCalculator _levelCalculator;

  DashboardAnalytics calculate({
    required List<Habit> habits,
    required List<HabitLogEntity> logs,
    required CalendarViewModel calendar,
  }) {
    //------------------------------------------
    // Empty State
    //------------------------------------------

    if (habits.isEmpty) {
      final empty = DashboardAnalytics.empty(
        calendar: calendar,
      );

      return empty.copyWith(
        cards: AnalyticsCardBuilder.build(empty),
      );
    }

    //------------------------------------------
    // Analytics
    //------------------------------------------

    final streak = StreakCalculator.calculate(logs);
    debugPrint(
      'Calculator Result -> '
      'Current=${streak.currentStreak}, '
      'Best=${streak.longestStreak}',
    );
    final metrics = MetricsCalculator.calculate(
      habits,
      logs,
    );

    final levelSummary = _levelCalculator.calculate(
      _calculateTotalXp(logs),
    );

    final weekly = WeeklyProgressCalculator.calculate(
      habits,
      logs,
    );

    final activities = ActivityCalculator.calculate(logs);

    final heatmap = HeatmapCalculator.calculate(logs);

    final analytics = DashboardAnalytics(
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      totalHabits: metrics.totalHabits,
      completedToday: metrics.completedToday,
      pendingToday: metrics.pendingToday,
      weeklyCompletion: metrics.weeklyCompletion,
      monthlyCompletion: metrics.monthlyCompletion,
      completionRate: metrics.completionRate,
      progress: metrics.progress,
      perfectDays: streak.perfectDays,
      completedDays: streak.completedDays,
      targetDays: metrics.totalHabits * 30,
      cards: const [],
      calendar: calendar,
      weekly: weekly,
      recentActivity: activities,
      heatmap: heatmap,
      levelSummary: levelSummary,
    );

    return analytics.copyWith(
      cards: AnalyticsCardBuilder.build(analytics),
    );
  }

  int _calculateTotalXp(
    List<HabitLogEntity> logs,
  ) {
    return logs.fold(
      0,
      (sum, log) => sum + log.xpEarned,
    );
  }
}
