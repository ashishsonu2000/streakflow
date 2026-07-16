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
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: Row(
          children: [
            //------------------------------------------------
            // Avatar
            //------------------------------------------------

            TodayHabitAvatar(
              habit: habit,
            ),

            const SizedBox(width: 18),

            //------------------------------------------------
            // Info
            //------------------------------------------------

            Expanded(
              child: TodayHabitInfo(
                habit: habit,
              ),
            ),

            const SizedBox(width: 12),

            //------------------------------------------------
            // Complete
            //------------------------------------------------

            TodayHabitCheckbox(
              completed: habit.completed,
              onPressed: onComplete,
            ),
          ],
        ),
      ),
    );
  }
}
