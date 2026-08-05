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
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: AppSpacing.sm,
      spacing: AppSpacing.sm,
      children: [
        AppStatBadge(
          icon: Icons.local_fire_department,
          label:
              '${habit.currentStreak} ${habit.currentStreak == 1 ? 'Day' : 'Days'}',
          color: Colors.orange,
        ),
        AppStatBadge(
          icon: habit.completedToday
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          label: habit.completedToday ? 'Completed' : 'Pending',
          color: habit.completedToday ? Colors.green : Colors.grey,
        ),
      ],
    );
  }
}
