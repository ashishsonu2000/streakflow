import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.label,
    this.showPercentage = true,
    this.height = 8,
    this.color,
  });

  final double value;
  final String? label;
  final bool showPercentage;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0);
    final theme = Theme.of(context);
    final progressColor = color ?? theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercentage)
          Row(
            children: [
              if (label != null)
                Expanded(
                  child: Text(
                    label!,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              if (showPercentage)
                Text(
                  "${(progress * 100).round()}%",
                  style: theme.textTheme.labelMedium,
                ),
            ],
          ),
        if (label != null || showPercentage)
          const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: height,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(progressColor),
          ),
        ),
      ],
    );
  }
}
