import '../models/analytics_card_model.dart';
import '../models/dashboard_analytics.dart';
import '../models/dashboard_metric_type.dart';

class AnalyticsCardBuilder {
  const AnalyticsCardBuilder();

  static List<AnalyticsCardModel> build(
    DashboardAnalytics analytics,
  ) {
    return [
      AnalyticsCardModel(
        type: DashboardMetricType.streak,
        title: 'Current Streak',
        value: analytics.currentStreak.toString(),
        subtitle: 'Best: ${analytics.longestStreak} days',
      ),
      AnalyticsCardModel(
        type: DashboardMetricType.xp,
        title: 'Level ${analytics.levelSummary.level}',
        value: '${analytics.levelSummary.totalXp} XP',
        subtitle: '${analytics.levelSummary.remainingXp} XP to next level',
        progress: analytics.levelSummary.progress,
      ),
      AnalyticsCardModel(
        type: DashboardMetricType.completion,
        title: 'Completion',
        value: '${analytics.completionRate.toStringAsFixed(0)}%',
        progress: analytics.completionRate / 100,
      ),
      AnalyticsCardModel(
        type: DashboardMetricType.consistency,
        title: 'Weekly Consistency',
        value: '${analytics.weeklyCompletion.toStringAsFixed(0)}%',
        progress: analytics.weeklyCompletion / 100,
      ),
      AnalyticsCardModel(
        type: DashboardMetricType.habits,
        title: 'Today',
        value: '${analytics.completedToday}/${analytics.totalHabits}',
        subtitle: '${analytics.pendingToday} remaining',
      ),
    ];
  }
}
