import 'package:flutter/material.dart';

import '../../../domain/models/habit.dart';

class PerformanceInsightsCard extends StatelessWidget {
  const PerformanceInsightsCard({
    super.key,
    required this.habit,
    required this.analytics,
  });

  final Habit habit;
  final dynamic analytics;

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
              'Performance Insights',
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
                  child: _InsightTile(
                    icon: Icons.local_fire_department,
                    title: 'Current streak',
                    value:
                    '${habit.currentStreak} days',
                  ),
                ),
                Expanded(
                  child: _InsightTile(
                    icon: Icons.emoji_events,
                    title: 'Best streak',
                    value:
                    '${habit.bestStreak} days',
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            Row(
              children: [
                Expanded(
                  child: _InsightTile(
                    icon: Icons.check_circle,
                    title: 'Completed',
                    value:
                    '${habit.totalCompleted}',
                  ),
                ),
                Expanded(
                  child: _InsightTile(
                    icon: Icons.stars,
                    title: 'XP earned',
                    value:
                    '${habit.xp}',
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

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        12,
      ),
      child: Column(
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

          const SizedBox(
            height: 4,
          ),

          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
    );
  }
}