import 'activity_item.dart';
import 'insight_item.dart';
import 'quick_action_model.dart';
import 'today_habit_view_model.dart';

class DashboardSections {
  const DashboardSections({
    required this.todayHabits,
    required this.activities,
    required this.actions,
    required this.insights,
    required this.hasHabits,
    required this.hasActivities,
  });

  final List<TodayHabitViewModel> todayHabits;

  final List<ActivityItem> activities;

  final List<QuickActionModel> actions;

  final List<InsightItem> insights;

  final bool hasHabits;

  final bool hasActivities;
}
