import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';
import '../../domain/habit_summary_mapper.dart';

import '../../domain/models/dashboard_view_model.dart';
import '../../domain/models/quick_action.dart';
import '../../domain/models/quick_action_type.dart';
import '../../domain/models/streak_summary.dart';
import '../../domain/models/weekly_progress.dart';
import '../../../habits/data/entities/habit_log_entity.dart';
import '../../domain/services/dashboard_analytics_service.dart';
import 'dashboard_provider.dart';

final dashboardAnalyticsProvider = Provider<DashboardAnalyticsService>((ref) {
  return const DashboardAnalyticsService();
});

final dashboardViewModelProvider =
    Provider<AsyncValue<DashboardViewModel>>((ref) {
  final habitsAsync = ref.watch(habitsProvider);
  final logsAsync = ref.watch(habitLogsProvider);

  final analytics = ref.watch(dashboardAnalyticsProvider);

  const summaryMapper = HabitSummaryMapper();

  return habitsAsync.whenData((habits) {
    return logsAsync.when(
      data: (logs) {
        final dashboardAnalytics = analytics.calculate(
          habits,
          logs,
        );

        return DashboardViewModel(
          greeting: "Good Morning",
          userName: "Ashish",
          streak: StreakSummary(
            currentStreak: dashboardAnalytics.currentStreak,
            longestStreak: dashboardAnalytics.longestStreak,
            completedDays: dashboardAnalytics.completedDays,
            targetDays: dashboardAnalytics.targetDays,
            completion: dashboardAnalytics.totalHabits == 0
                ? 0
                : dashboardAnalytics.completedToday /
                    dashboardAnalytics.totalHabits,
            level: dashboardAnalytics.level,
            xp: dashboardAnalytics.totalXp,
            xpTarget: dashboardAnalytics.xpTarget,
            achievement: dashboardAnalytics.achievement,
          ),
          habits: habits.map(summaryMapper.toSummary).toList(),
          actions: const [
            QuickAction(
              title: "Add Habit",
              icon: Icons.add_circle_outline,
              type: QuickActionType.addHabit,
            ),
            QuickAction(
              title: "Calendar",
              icon: Icons.calendar_month,
              type: QuickActionType.calendar,
            ),
            QuickAction(
              title: "Statistics",
              icon: Icons.bar_chart,
              type: QuickActionType.statistics,
            ),
            QuickAction(
              title: "Settings",
              icon: Icons.settings,
              type: QuickActionType.settings,
            ),
          ],
          weekly: dashboardAnalytics.weeklyProgress
              .map(
                (e) => WeeklyProgress(
                  day: _getWeekdayLabel(e.date.weekday),
                  completed: e.completed,
                ),
              )
              .toList(),
          recentActivity: const [],
        );
      },
      loading: () => throw Exception(),
      error: (e, s) => throw e,
    );
  });
});

String _getWeekdayLabel(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return "M";
    case DateTime.tuesday:
      return "T";
    case DateTime.wednesday:
      return "W";
    case DateTime.thursday:
      return "T";
    case DateTime.friday:
      return "F";
    case DateTime.saturday:
      return "S";
    case DateTime.sunday:
      return "S";
    default:
      return "";
  }
}
