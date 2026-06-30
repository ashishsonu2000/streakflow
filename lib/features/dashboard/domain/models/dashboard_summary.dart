import 'dashboard_metrics.dart';
import 'habit_summary.dart';
import 'quick_action.dart';
import 'streak_summary.dart';
import 'weekly_progress.dart';
import 'activity_item.dart';

class DashboardSummary {
  final String greeting;

  final String userName;

  final StreakSummary streak;

  final List<HabitSummary> habits;

  final List<QuickAction> actions;

  final List<WeeklyProgress> weekly;

  final DashboardMetrics metrics;

  final List<ActivityItem> recentActivity;

  const DashboardSummary({
    required this.greeting,
    required this.userName,
    required this.streak,
    required this.habits,
    required this.actions,
    required this.weekly,
    required this.recentActivity,
    required this.metrics,
  });
}
