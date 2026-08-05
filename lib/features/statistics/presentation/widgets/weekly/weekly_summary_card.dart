import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_section_card.dart';

import '../../../domain/models/weekly_statistics.dart';
import '../../../domain/models/weekly_trend.dart';

class WeeklySummaryCard extends StatelessWidget {
  const WeeklySummaryCard({
    super.key,
    required this.weekly,
  });

  final WeeklyStatistics weekly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final completion = (weekly.completionRate * 100).toStringAsFixed(0);

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

    return AppSectionCard(
      title: 'This Week',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Completion',
                  value: '$completion%',
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Completed',
                  value: '${weekly.totalCompleted}/${weekly.totalTarget}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'XP',
                  value: '${weekly.totalXP}',
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Duration',
                  value: '${weekly.totalDurationMinutes} min',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Active Days',
                  value: '${weekly.activeDays}/7',
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Trend',
                  value: '${weekly.weeklyChangePercentage.toStringAsFixed(1)}%',
                  valueColor: trendColor,
                  trailing: Icon(
                    trendIcon,
                    color: trendColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Best Day',
                  value: _weekday(
                    weekly.bestDay.date,
                  ),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Needs Attention',
                  value: _weekday(
                    weekly.worstDay.date,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _weekday(DateTime date) {
    const names = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return names[date.weekday - 1];
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.trailing,
    this.valueColor,
  });

  final String label;
  final String value;
  final Widget? trailing;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 6),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
