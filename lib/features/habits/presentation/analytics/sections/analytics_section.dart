import 'package:flutter/material.dart';

import '../../../domain/models/analytics_summary.dart';

import '../cards/completion_rate_card.dart';
import '../cards/heatmap_preview_card.dart';

import '../cards/insight_card.dart';
import '../cards/monthly_progress_card.dart';
import '../cards/statistic_grid.dart';
import '../cards/weekly_progress_card.dart';

import '../../mapper/statistic_tile_mapper.dart';

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({
    super.key,
    required this.analytics,
  });

  final AnalyticsSummary analytics;

  @override
  Widget build(BuildContext context) {
    final mapper = StatisticTileMapper();

    final statisticTiles = mapper.map(analytics.statistics);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //--------------------------------------------------
        // Statistics
        //--------------------------------------------------

        StatisticGrid(
          tiles: statisticTiles,
        ),

        const SizedBox(height: 24),

        //--------------------------------------------------
        // Weekly Progress
        //--------------------------------------------------

        WeeklyProgressCard(
          progress: analytics.weeklyProgress,
        ),

        const SizedBox(height: 24),

        //--------------------------------------------------
        // Completion
        //--------------------------------------------------

        CompletionRateCard(
          completionRate: analytics.statistics.completionRate,
        ),

        const SizedBox(height: 24),

        //--------------------------------------------------
        // Monthly
        //--------------------------------------------------

        MonthlyProgressCard(
          progress: analytics.monthlyProgress,
        ),

        const SizedBox(height: 24),

        //--------------------------------------------------
        // Heatmap
        //--------------------------------------------------

        HeatmapPreviewCard(
          days: analytics.heatmap,
        ),

        const SizedBox(height: 24),

        //--------------------------------------------------
        // Insight
        //--------------------------------------------------

        InsightCard(
          statistics: analytics.statistics,
        ),
      ],
    );
  }
}
