import 'package:flutter/material.dart';

import '../../domain/models/statistic_tile.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard({
    super.key,
    required this.stat,
  });

  final StatisticTileModel stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = stat.color ?? theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(.12),
            child: Icon(
              stat.icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            stat.value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
