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
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    final completed = habit.completed;

    // =============================================================
    // THEME-AWARE TEXT COLORS
    // =============================================================

    final titleColor = completed
        ? isDark
        ? colors.onSurface.withValues(
      alpha: 0.82,
    )
        : const Color(0xFF475569)
        : colors.onSurface;

    final streakColor = completed
        ? isDark
        ? colors.onSurfaceVariant.withValues(
      alpha: 0.80,
    )
        : colors.outline.withValues(
      alpha: 0.75,
    )
        : colors.onSurfaceVariant;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
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
            color: titleColor,
            fontWeight: completed
                ? FontWeight.w600
                : FontWeight.w700,
            letterSpacing: -0.1,
            height: 1.2,
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
              color: isDark
                  ? const Color(0xFFFB923C)
                  : Colors.orange,
              size: 15,
            ),

            const SizedBox(width: 4),

            Text(
              '${habit.currentStreak} '
                  '${habit.currentStreak == 1 ? 'day' : 'days'} '
                  'streak',
              style: theme.textTheme.bodySmall?.copyWith(
                color: streakColor,
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