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
    return CircleAvatar(
      radius: 24,
      backgroundColor: habit.color.withValues(alpha: .15),
      child: Icon(
        habit.icon,
        color: habit.color,
        size: 24,
      ),
    );
  }
}
