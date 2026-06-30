import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';

/// ===============================================================
///
/// AppProgressBar
///
/// Generic animated progress bar used throughout the application.
///
/// Examples:
///
/// • Streak Progress
/// • XP Progress
/// • Habit Completion
/// • Weekly Goals
/// • Monthly Goals
///
/// ===============================================================

class AppProgressBar extends StatelessWidget {
  final double value;

  final String? label;

  final double height;

  final Color? progressColor;

  final Color? backgroundColor;

  final bool showPercentage;

  final Duration duration;

  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 10,
    this.progressColor,
    this.backgroundColor,
    this.showPercentage = true,
    this.duration = const Duration(milliseconds: 700),
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(
            begin: 0,
            end: progress,
          ),
          duration: duration,
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.round),
              child: LinearProgressIndicator(
                value: animatedValue,
                minHeight: height,
                color: progressColor ?? AppColors.primary,
                backgroundColor:
                    backgroundColor ?? AppColors.progressBackground,
              ),
            );
          },
        ),
        if (showPercentage) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(progress * 100).round()}%",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }
}
