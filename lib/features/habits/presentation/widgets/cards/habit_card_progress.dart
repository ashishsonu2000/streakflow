import 'package:flutter/material.dart';

import '../../../../../core/ui/progress/animated_linear_progress.dart';
import '../../../../../core/ui/progress/app_progress_header.dart';
import '../../../../../core/ui/spacing/app_spacing.dart';
import '../../../domain/models/habit.dart';

class HabitCardProgress extends StatelessWidget {
  const HabitCardProgress({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    const progress = 0.65;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppProgressHeader(
          label: 'Today\'s Progress',
          progress: progress,
        ),
        const Gap.vertical(AppSpacing.sm),
        const AnimatedLinearProgress(
          progress: progress,
        ),
      ],
    );
  }
}
