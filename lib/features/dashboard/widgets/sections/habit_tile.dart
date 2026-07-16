import 'package:flutter/material.dart';

import '../../domain/models/today_habit_view_model.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    this.onChanged,
  });

  final TodayHabitViewModel habit;

  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CheckboxListTile(
      value: habit.completed,
      onChanged: (value) {
        if (value != null) {
          onChanged?.call(value);
        }
      },
      secondary: CircleAvatar(
        backgroundColor: habit.color,
        child: Icon(
          habit.icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        habit.title,
        style: text.titleMedium?.copyWith(
          decoration: habit.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        "🔥 ${habit.currentStreak} day streak",
        style: text.bodySmall,
      ),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
