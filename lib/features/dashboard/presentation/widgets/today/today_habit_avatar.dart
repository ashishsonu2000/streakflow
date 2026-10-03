import 'package:flutter/material.dart';

import '../../../domain/models/today_habit_view_model.dart';

class TodayHabitAvatar extends StatelessWidget {
  const TodayHabitAvatar({
    super.key,
    required this.habit,
  });

  final TodayHabitViewModel habit;

  @override
  Widget build(BuildContext context) {
    final completed = habit.completed;

    final avatarColor = habit.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatarColor.withValues(
          alpha: completed ? 0.10 : 0.14,
        ),
        border: Border.all(
          color: avatarColor.withValues(
            alpha: completed ? 0.06 : 0.08,
          ),
        ),
      ),
      child: Icon(
        habit.icon,
        color: avatarColor.withValues(
          alpha: completed ? 0.75 : 1.0,
        ),
        size: 22,
      ),
    );
  }
}