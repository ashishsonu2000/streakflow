import 'package:flutter/material.dart';

import '../../../../core/ui/indicators/app_progress_bar.dart';

import '../../../../shared/ui/cards/app_card.dart';
import '../../domain/models/hero_view_model.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.hero,
  });

  final HeroViewModel hero;

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
            '${hero.currentStreak}',
            style: theme.textTheme.displayLarge,
          ),
          Text(
            "Days",
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          AppProgressBar(
            label: "Today's Progress",
            value: hero.progress,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${hero.progressPercentage}%",
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat(
                label: "Completed",
                value: '${hero.completedToday}',
              ),
              _Stat(
                label: "Today",
                value: '${hero.totalToday}',
              ),
              _Stat(
                label: "Best",
                value: '${hero.bestStreak}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
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
