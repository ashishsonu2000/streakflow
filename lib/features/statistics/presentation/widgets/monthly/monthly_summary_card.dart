import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_section_card.dart';
import '../../../domain/models/monthly_statistics.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    super.key,
    required this.monthly,
  });

  final MonthlyStatistics monthly;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'This Month',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: 'Completion',
                  value: '${(monthly.monthlyCompletionRate * 100).round()}%',
                ),
              ),
              Expanded(
                child: _Metric(
                  title: 'Perfect Days',
                  value: '${monthly.perfectDays}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: 'Completed',
                  value: '${monthly.totalCompleted}',
                ),
              ),
              Expanded(
                child: _Metric(
                  title: 'XP',
                  value: '${monthly.totalXP}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: 'Duration',
                  value: '${monthly.totalDurationMinutes} min',
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
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
