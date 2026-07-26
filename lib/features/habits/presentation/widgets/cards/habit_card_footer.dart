import 'package:flutter/material.dart';

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
    return Row(
      children: [
        const AppStatBadge(
          icon: Icons.local_fire_department,
          label: '18 Days',
          color: Colors.orange,
        ),
        const Spacer(),
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
