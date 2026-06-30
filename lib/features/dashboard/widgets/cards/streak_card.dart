import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/models/streak_summary.dart';
import '../../../../core/ui/indicators/app_progress_bar.dart';

class StreakCard extends StatelessWidget {
  final StreakSummary streak;

  const StreakCard({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                "Current Streak",
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            streak.currentStreak.toString(),
            style: theme.textTheme.displayLarge,
          ),
          Text(
            "Days",
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          AppProgressBar(
            label: "XP",
            value: streak.xpProgress,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(streak.completion * 100).round()}%",
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat(
                label: "Completed",
                value: streak.completedDays.toString(),
              ),
              _Stat(
                label: "Target",
                value: streak.targetDays.toString(),
              ),
              _Stat(
                label: "Success",
                value:
                    "${((streak.completedDays / streak.targetDays) * 100).round()}%",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall,
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
