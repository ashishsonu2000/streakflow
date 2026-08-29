import 'package:flutter/material.dart';

import '../../domain/models/habit_detail.dart';

class DetailProgressSection extends StatelessWidget {
  const DetailProgressSection({
    super.key,
    required this.detail,
  });

  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final progress = detail.completionRate.clamp(0.0, 1.0);



    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.show_chart,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  "Completion Progress",
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: progress,
              ),
              duration: const Duration(
                milliseconds: 900,
              ),
              curve: Curves.easeOutCubic,
              builder: (_, value, __) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: LinearProgressIndicator(
                        minHeight: 14,
                        value: value,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "${(value * 100).round()}%",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _ProgressTile(
                    icon: Icons.task_alt,
                    title: "Completed",
                    value: "${detail.habit.totalCompleted}",
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _ProgressTile(
                    icon: Icons.flag,
                    title: "Target",
                    value: "${detail.habit.targetPerDay}/day",
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: detail.habit.completedToday
                    ? Colors.green.withValues(alpha: .12)
                    : Colors.orange.withValues(alpha: .12),
              ),
              child: Row(
                children: [
                  Icon(
                    detail.habit.completedToday
                        ? Icons.check_circle
                        : Icons.pending_actions,
                    color: detail.habit.completedToday
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      detail.habit.completedToday
                          ? "Completed today 🎉"
                          : "Pending for today",
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;

  final String title;

  final String value;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color.withValues(alpha: .12),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(title),
      ],
    );
  }
}
