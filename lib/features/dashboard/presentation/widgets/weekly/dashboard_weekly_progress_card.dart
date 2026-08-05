import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_card.dart';
import '../../../../../../core/ui/design/app_spacing.dart';
import '../../../../../../core/ui/section/app_section_header.dart';

import '../../../domain/models/weekly_progress_view_model.dart';
import '../../../../statistics/domain/models/weekly_trend.dart';

class DashboardWeeklyProgressCard extends StatelessWidget {
  const DashboardWeeklyProgressCard({
    super.key,
    required this.weekly,
  });

  final WeeklyProgressViewModel weekly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final trendColor = switch (weekly.trend) {
      WeeklyTrend.improving => Colors.green,
      WeeklyTrend.declining => Colors.red,
      WeeklyTrend.stable => theme.colorScheme.primary,
    };

    final trendIcon = switch (weekly.trend) {
      WeeklyTrend.improving => Icons.trending_up,
      WeeklyTrend.declining => Icons.trending_down,
      WeeklyTrend.stable => Icons.trending_flat,
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            title: 'Weekly Progress',
          ),
          const SizedBox(height: AppSpacing.cardSpacing),
          LinearProgressIndicator(
            value: weekly.completionRate,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: AppSpacing.sectionSpacing),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Completed',
                  value: '${weekly.completed}/${weekly.target}',
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'XP',
                  value: '${weekly.totalXP}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardSpacing),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Active Days',
                  value: '${weekly.activeDays}/7',
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      trendIcon,
                      size: 18,
                      color: trendColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${weekly.changePercentage.toStringAsFixed(1)}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: trendColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
