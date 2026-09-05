import 'package:flutter/material.dart';

import '../../../domain/models/today_habit_view_model.dart';

import 'today_habit_avatar.dart';
import 'today_habit_checkbox.dart';
import 'today_habit_info.dart';

class TodayHabitTile extends StatelessWidget {
  const TodayHabitTile({
    super.key,
    required this.habit,
    this.onTap,
    this.onToggle,
  });

  final TodayHabitViewModel habit;

  final VoidCallback? onTap;

  /// Completes or undoes today's habit.
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    final completed = habit.completed;

    const blue = Color(0xFF2563EB);

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(
        vertical: 3,
      ),

      decoration: BoxDecoration(
        // =========================================================
        // COMPLETED TILE BACKGROUND
        // =========================================================

        color: completed
            ? isDark
            ? colors.surfaceContainerHighest
            : const Color(0xFFEFF6FF)
            : Colors.transparent,

        borderRadius:
        BorderRadius.circular(16),

        // =========================================================
        // BORDER
        // =========================================================

        border: completed
            ? Border.all(
          color: isDark
              ? colors.outlineVariant.withValues(
            alpha: 0.65,
          )
              : blue.withValues(
            alpha: 0.10,
          ),
          width: 1,
        )
            : null,

        // =========================================================
        // SUBTLE SHADOW
        // =========================================================

        boxShadow: completed && isDark
            ? [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.12,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ]
            : null,
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius:
          BorderRadius.circular(16),

          splashColor: colors.primary.withValues(
            alpha: 0.10,
          ),

          highlightColor: colors.primary.withValues(
            alpha: 0.05,
          ),

          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 6,
            ),

            child: Row(
              children: [
                // =================================================
                // HABIT AVATAR
                // =================================================

                TodayHabitAvatar(
                  habit: habit,
                ),

                const SizedBox(width: 14),

                // =================================================
                // HABIT INFORMATION
                // =================================================

                Expanded(
                  child: TodayHabitInfo(
                    habit: habit,
                  ),
                ),

                const SizedBox(width: 10),

                // =================================================
                // CHECKBOX
                // =================================================

                TodayHabitCheckbox(
                  completed: completed,
                  onPressed: onToggle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}