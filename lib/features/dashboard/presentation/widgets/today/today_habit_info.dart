import 'package:flutter/material.dart';

import '../../../domain/models/today_habit_view_model.dart';

class TodayHabitInfo extends StatelessWidget {
  const TodayHabitInfo({
    super.key,
    required this.habit,
  });

  final TodayHabitViewModel habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          habit.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            decoration: habit.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              "${habit.currentStreak} day streak",
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
