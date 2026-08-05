import '../../../../core/ui/insights/insight_item.dart';

import 'activity_item.dart';
import 'quick_action_model.dart';
import 'today_habit_view_model.dart';
import 'weekly_progress_view_model.dart';

class DashboardSections {
  const DashboardSections({
    required this.todayHabits,
    required this.activities,
    required this.actions,
    required this.insights,
    required this.weeklyProgress,
    required this.hasHabits,
    required this.hasActivities,
  });

  /// Today's habits
  final List<TodayHabitViewModel> todayHabits;

  /// Recent activity
  final List<ActivityItem> activities;

  /// Quick actions
  final List<QuickActionModel> actions;

  /// Dashboard insights
  final List<InsightItem> insights;

  /// Weekly progress summary
  final WeeklyProgressViewModel weeklyProgress;

  /// UI helpers
  final bool hasHabits;

  final bool hasActivities;

  DashboardSections copyWith({
    List<TodayHabitViewModel>? todayHabits,
    List<ActivityItem>? activities,
    List<QuickActionModel>? actions,
    List<InsightItem>? insights,
    WeeklyProgressViewModel? weeklyProgress,
    bool? hasHabits,
    bool? hasActivities,
  }) {
    return DashboardSections(
      todayHabits: todayHabits ?? this.todayHabits,
      activities: activities ?? this.activities,
      actions: actions ?? this.actions,
      insights: insights ?? this.insights,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      hasHabits: hasHabits ?? this.hasHabits,
      hasActivities: hasActivities ?? this.hasActivities,
    );
  }
}
