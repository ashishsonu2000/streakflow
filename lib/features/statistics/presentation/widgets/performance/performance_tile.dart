import 'package:flutter/material.dart';

import '../../../domain/models/habit_performance.dart';

class PerformanceTile extends StatelessWidget {
  const PerformanceTile({
    super.key,
    required this.performance,
  });

  final HabitPerformance performance;

  @override
  Widget build(BuildContext context) {
    final completion = (performance.completionRate * 100).clamp(0, 100);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //--------------------------------------------------
            // Header
            //--------------------------------------------------

            Row(
              children: [
                Expanded(
                  child: Text(
                    performance.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  "${completion.round()}%",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: performance.completionRate,
              minHeight: 8,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: "Completed",
                    value: "${performance.totalCompleted}",
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: "Current",
                    value: "${performance.currentStreak}",
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: "Best",
                    value: "${performance.bestStreak}",
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: "XP",
                    value: "${performance.totalXP}",
                  ),
                ),
              ],
            ),
          ],
        ),
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
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
