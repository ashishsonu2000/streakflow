import '../../../../core/ui/analytics/analytics_card_model.dart';
import '../../../../core/ui/analytics/analytics_metric_type.dart';

import '../../domain/models/overview_statistics.dart';

class OverviewMapper {
  const OverviewMapper();

  List<AnalyticsCardModel> map(
    OverviewStatistics overview,
  ) {
    return [
      AnalyticsCardModel(
        type: AnalyticsMetricType.completion,
        title: 'Completion',
        value: '${(overview.completionRate * 100).round()}%',
        subtitle: 'Overall',
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.streak,
        title: 'Current Streak',
        value: '${overview.currentStreak}',
        subtitle: 'Days',
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.streak,
        title: 'Best Streak',
        value: '${overview.bestStreak}',
        subtitle: 'Days',
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.xp,
        title: 'XP',
        value: '${overview.totalXP}',
        subtitle: 'Earned',
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.consistency,
        title: 'Duration',
        value: '${overview.totalDurationMinutes}',
        subtitle: 'Minutes',
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.habits,
        title: 'Perfect Days',
        value: '${overview.perfectDays}',
        subtitle: 'Completed',
      ),
    ];
  }
}
