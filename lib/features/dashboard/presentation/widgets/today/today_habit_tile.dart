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
    final completed = habit.completed;

    const blue = Color(0xFF2563EB);
    const lightBlue = Color(0xFFEFF6FF);

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: completed
            ? lightBlue
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: completed
            ? Border.all(
          color: blue.withValues(
            alpha: 0.10,
          ),
        )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 6,
            ),
            child: Row(
              children: [
                TodayHabitAvatar(
                  habit: habit,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: TodayHabitInfo(
                    habit: habit,
                  ),
                ),

                const SizedBox(width: 10),

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