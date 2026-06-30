import 'package:flutter/material.dart';

import '../../domain/models/habit_summary.dart';

class HabitTile extends StatelessWidget {
  final HabitSummary habit;

  const HabitTile({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CheckboxListTile(
      value: habit.completed,
      onChanged: (_) {},
      secondary: Text(
        habit.icon as String,
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(
        habit.title,
        style: text.titleMedium,
      ),
      subtitle: Text(
        "+${habit.points} points",
        style: text.bodySmall,
      ),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
