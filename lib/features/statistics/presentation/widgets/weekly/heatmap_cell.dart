import 'package:flutter/material.dart';

class HeatmapCell extends StatelessWidget {
  const HeatmapCell({
    super.key,
    required this.completions,
  });

  final int completions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color color;

    if (completions == 0) {
      color =
          theme.colorScheme.surfaceContainerHighest;
    } else if (completions == 1) {
      color =
          theme.colorScheme.primary.withValues(
            alpha: 0.4,
          );
    } else {
      color = theme.colorScheme.primary;
    }

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
        BorderRadius.circular(4),
      ),
    );
  }
}