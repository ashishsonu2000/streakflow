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
    final completed = habit.completed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // =============================================================
        // HABIT TITLE
        // =============================================================

        Text(
          habit.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: completed
                ? FontWeight.w500
                : FontWeight.w700,
            letterSpacing: -0.1,
            height: 1.2,
            color: completed
                ? const Color(0xFF475569)
                : const Color(0xFF0F172A),
            decoration: TextDecoration.none,
          ),
        ),

        const SizedBox(height: 5),

        // =============================================================
        // STREAK
        // =============================================================

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              color: Colors.orange,
              size: 15,
            ),

            const SizedBox(width: 4),

            Text(
              '${habit.currentStreak} '
                  '${habit.currentStreak == 1 ? 'day' : 'day'} '
                  'streak',
              style: theme.textTheme.bodySmall?.copyWith(
                color: completed
                    ? theme.colorScheme.outline.withValues(
                  alpha: 0.75,
                )
                    : theme.colorScheme.outline,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}