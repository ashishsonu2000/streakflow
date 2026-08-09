import 'package:flutter/material.dart';

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
        icon: Icons.check_circle,          // ✅ ADD
        color: Colors.green,               // ✅ ADD
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.streak,
        title: 'Current Streak',
        value: '${overview.currentStreak}',
        subtitle: 'Days',
        icon: Icons.local_fire_department, // ✅ ADD
        color: Colors.orange,              // ✅ ADD
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.streak,
        title: 'Best Streak',
        value: '${overview.bestStreak}',
        subtitle: 'Days',
        icon: Icons.emoji_events,          // ✅ ADD
        color: Colors.amber,               // ✅ ADD
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.xp,
        title: 'XP',
        value: '${overview.totalXP}',
        subtitle: 'Earned',
        icon: Icons.flash_on,              // ✅ ADD
        color: Colors.deepPurple,          // ✅ ADD
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.consistency,
        title: 'Duration',
        value: '${overview.totalDurationMinutes}',
        subtitle: 'Minutes',
        icon: Icons.timer,                 // ✅ ADD
        color: Colors.blue,                // ✅ ADD
      ),
      AnalyticsCardModel(
        type: AnalyticsMetricType.habits,
        title: 'Perfect Days',
        value: '${overview.perfectDays}',
        subtitle: 'Completed',
        icon: Icons.star,                  // ✅ ADD
        color: Colors.teal,                // ✅ ADD
      ),
    ];
  }
}