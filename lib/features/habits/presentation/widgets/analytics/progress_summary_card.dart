import 'package:flutter/material.dart';

import '../../../domain/models/habit.dart';

class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Summary',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Expanded(
                  child: _Metric(
                    icon:
                    Icons.local_fire_department,
                    value:
                    '${habit.currentStreak}',
                    label:
                    'Current',
                  ),
                ),
                Expanded(
                  child: _Metric(
                    icon:
                    Icons.emoji_events,
                    value:
                    '${habit.bestStreak}',
                    label:
                    'Best',
                  ),
                ),
                Expanded(
                  child: _Metric(
                    icon:
                    Icons.check_circle,
                    value:
                    '${habit.totalCompleted}',
                    label:
                    'Completed',
                  ),
                ),
                Expanded(
                  child: _Metric(
                    icon: Icons.stars,
                    value:
                    '${habit.xp}',
                    label: 'XP',
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
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),

        const SizedBox(
          height: 8,
        ),

        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),

        Text(label),
      ],
    );
  }
}