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

import '../activity/statistics_activity_section.dart';
import '../monthly/monthly_summary_card.dart';
import '../performance/performance_section.dart';
import '../weekly/weekly_summary_card.dart';

class StatisticsBody extends StatelessWidget {
  const StatisticsBody({
    super.key,
    required this.statistics,
  });

  final StatisticsSummary statistics;

  @override
  Widget build(BuildContext context) {
    // ===============================================================
    // DATA MAPPING
    // ===============================================================

    final analytics = const OverviewMapper().map(
      statistics.overview,
    );

    final insights = const InsightMapper().map(
      statistics.insights,
    );

    final weeklyChart =
    const ChartDataMapper().map(
      trends: statistics.trends,
      type: ChartType.weekly,
    );

    final monthlyChart =
    const ChartDataMapper().map(
      trends: statistics.trends,
      type: ChartType.monthly,
    );

    // ===============================================================
    // BODY
    // ===============================================================

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // =============================================================
        // OVERVIEW
        // =============================================================

        AppSectionCard(
          title: 'Overview',
          child: AnalyticsGrid(
            analytics: analytics,
          ),
        ),

        const SizedBox(
          height: AppSpacing.sectionGap,
        ),

        // =============================================================
        // WEEKLY SUMMARY
        // =============================================================

        WeeklySummaryCard(
          weekly: statistics.weekly,
        ),

        const SizedBox(
          height: AppSpacing.sectionGap,
        ),

        // =============================================================
        // WEEKLY CHART
        // =============================================================

        StatisticsChart(
          title: 'Weekly Progress',
          points: weeklyChart,
        ),

        const SizedBox(
          height: AppSpacing.sectionGap,
        ),

        // =============================================================
        // MONTHLY SUMMARY
        // =============================================================

        MonthlySummaryCard(
          monthly: statistics.monthly,
        ),

        const SizedBox(
          height: AppSpacing.sectionGap,
        ),

        // =============================================================
        // MONTHLY CHART
        // =============================================================

        StatisticsChart(
          title: 'Monthly Progress',
          points: monthlyChart,
        ),

        const SizedBox(
          height: AppSpacing.sectionGap,
        ),

        // =============================================================
        // PERFORMANCE
        // =============================================================

        PerformanceSection(
          performance: statistics.performance,
        ),

        const SizedBox(
          height: AppSpacing.sectionGap,
        ),

        // =============================================================
        // ACTIVITY
        // =============================================================

        StatisticsActivitySection(
          logs: statistics.logs,
        ),

        const SizedBox(
          height: AppSpacing.sectionGap,
        ),

        // =============================================================
        // INSIGHTS
        // =============================================================

        InsightsList(
          insights: insights,
        ),

        // =============================================================
        // BOTTOM SPACE
        // =============================================================

        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}