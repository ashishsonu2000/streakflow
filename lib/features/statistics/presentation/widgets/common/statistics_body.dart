import 'package:flutter/material.dart';

import '../../../../../core/ui/analytics/analytics_grid.dart';
import '../../../../../core/ui/charts/chart_data_mapper.dart';
import '../../../../../core/ui/charts/chart_type.dart';
import '../../../../../core/ui/charts/statistics_chart.dart';
import '../../../../../core/ui/design/app_spacing.dart';
import '../../../../../core/ui/insights/insights_list.dart';

import '../../../../../shared/ui/cards/app_section_card.dart';
import '../../../data/mapper/insight_mapper.dart';
import '../../../data/mapper/overview_mapper.dart';
import '../../../domain/models/statistics_summary.dart';

import '../performance/performance_section.dart';
import '../monthly/monthly_summary_card.dart';
import '../weekly/weekly_summary_card.dart';

class StatisticsBody extends StatelessWidget {
  const StatisticsBody({
    super.key,
    required this.statistics,
  });

  final StatisticsSummary statistics;

  @override
  Widget build(BuildContext context) {
    final analytics = const OverviewMapper().map(
      statistics.overview,
    );

    final insights = const InsightMapper().map(
      statistics.insights,
    );

    final chart = const ChartDataMapper().map(
      trends: statistics.trends,
      type: ChartType.weekly,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.pagePadding,
        AppSpacing.pagePadding,
        100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionCard(
            title: 'Overview',
            child: AnalyticsGrid(
              analytics: analytics,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          WeeklySummaryCard(
            weekly: statistics.weekly,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          StatisticsChart(
            title: 'Weekly Progress',
            points: chart,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          MonthlySummaryCard(
            monthly: statistics.monthly,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          PerformanceSection(
            performance: statistics.performance,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          InsightsList(
            insights: insights,
          ),
        ],
      ),
    );
  }
}
