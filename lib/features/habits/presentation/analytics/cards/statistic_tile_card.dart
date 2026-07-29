import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_card.dart';
import '../../../domain/models/statistic_tile.dart';
import '../widgets/animated_value_text.dart';

class StatisticTileCard extends StatelessWidget {
  const StatisticTileCard({
    super.key,
    required this.model,
  });

  final StatisticTileModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: (model.color ?? theme.colorScheme.primary)
                .withValues(alpha: 0.12),
            child: Icon(
              model.icon,
              color: model.color ?? theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedValueText(
            value: int.tryParse(model.value) ?? 0,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            model.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
