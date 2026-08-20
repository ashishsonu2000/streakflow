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
    this.onComplete,
  });

  final TodayHabitViewModel habit;

  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = habit.completed;



    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: completed
            ? theme.colorScheme.primary.withValues(alpha: 0.045)
            : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 9,
              horizontal: 4,
            ),
            child: Row(
              children: [
                // =======================================================
                // AVATAR
                // =======================================================

                TodayHabitAvatar(
                  habit: habit,
                ),

                const SizedBox(width: 14),

                // =======================================================
                // HABIT INFORMATION
                // =======================================================

                Expanded(
                  child: TodayHabitInfo(
                    habit: habit,
                  ),
                ),

                const SizedBox(width: 10),

                // =======================================================
                // COMPLETION
                // =======================================================

                TodayHabitCheckbox(
                  completed: completed,
                  onPressed: onComplete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}