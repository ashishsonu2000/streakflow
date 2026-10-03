import 'package:flutter/material.dart';

import '../../../../../core/ui/charts/chart_point.dart';
import '../../../../../core/ui/charts/statistics_chart.dart';

import '../../../../../../shared/ui/cards/app_card.dart';
import '../../../../../../core/ui/section/app_section_header.dart';

import '../../../domain/models/monthly_statistics.dart';

class MonthlySection extends StatelessWidget {
  const MonthlySection({
    super.key,
    required this.monthly,
    required this.chartPoints,
  });

  final MonthlyStatistics monthly;
  final List<ChartPoint> chartPoints;

  @override
  Widget build(BuildContext context) {
    final completion = (monthly.monthlyCompletionRate * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSectionHeader(
                title: 'This Month',
              ),
              const SizedBox(height: 20),
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
                      label: 'Perfect Days',
                      value: '${monthly.perfectDays}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      label: 'Completed',
                      value: '${monthly.totalCompleted}',
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      label: 'XP',
                      value: '${monthly.totalXP}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      label: 'Duration',
                      value: '${monthly.totalDurationMinutes} min',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        StatisticsChart(
          title: 'Monthly Progress',
          points: chartPoints,
        ),
      ],
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

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Column(
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
      ),
    );
  }
}
