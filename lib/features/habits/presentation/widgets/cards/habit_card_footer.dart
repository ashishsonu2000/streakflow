import 'package:flutter/material.dart';

import '../../../../../core/ui/spacing/app_spacing.dart';
import '../../../../../core/ui/stats/app_stat_badge.dart';
import '../../../domain/models/habit.dart';

class HabitCardFooter extends StatelessWidget {
  const HabitCardFooter({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final completed = habit.completedToday;

    return Row(
      children: [
        // =============================================================
        // STREAK
        // =============================================================

        Expanded(
          child: AppStatBadge(
            icon: Icons.local_fire_department_rounded,
            label:
            '${habit.currentStreak} '
                '${habit.currentStreak == 1 ? 'Day' : 'Days'}',
            color: Colors.orange,
          ),
        ),

        const SizedBox(
          width: AppSpacing.sm,
        ),

        // =============================================================
        // STATUS
        // =============================================================

        Expanded(
          child: AppStatBadge(
            icon: completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            label: completed
                ? 'Completed'
                : 'Pending',
            color: completed
                ? Colors.green
                : Colors.grey,
          ),
        ),
      ],
    );
  }
}