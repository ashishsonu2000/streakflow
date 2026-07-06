import '../../../dashboard/domain/models/dashboard_analytics.dart';
import 'daily_statistics.dart';
import 'habit_statistics.dart';

class StatisticsSummary {
  final DashboardAnalytics dashboard;

  final int totalXP;

  final int currentStreak;

  final int longestStreak;

  final int totalCompletions;

  final int completionRate;

  final List<DailyStatistics> weekly;

  final List<HabitStatistics> habits;

  final Map<DateTime, int> heatmap;

  const StatisticsSummary({
    required this.dashboard,
    required this.totalXP,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompletions,
    required this.completionRate,
    required this.weekly,
    required this.habits,
    required this.heatmap,
  });
}
