import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_card.dart';
import '../../../domain/models/monthly_progress.dart';

class MonthlyProgressCard extends StatelessWidget {
  const MonthlyProgressCard({
    super.key,
    required this.progress,
  });

  final MonthlyProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            progress.monthLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0,
              end: progress.completionRate,
            ),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: "Completed",
                  value: progress.completedDays.toString(),
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: _Metric(
                  label: "Missed",
                  value: progress.missedDays.toString(),
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: _Metric(
                  label: "Target",
                  value: progress.targetDays.toString(),
                  color: theme.colorScheme.primary,
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
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
