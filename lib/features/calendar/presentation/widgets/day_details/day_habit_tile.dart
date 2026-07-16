import 'package:flutter/material.dart';

import '../../../../habits/data/entities/habit_log_entity.dart';

class DayHabitTile extends StatelessWidget {
  const DayHabitTile({
    super.key,
    required this.log,
  });

  final HabitLogEntity log;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
      title: Text(
        log.habit.value?.title ?? 'Habit',
      ),
      subtitle: log.notes.isEmpty ? null : Text(log.notes),
      trailing: Text(
        "${log.xpEarned} XP",
      ),
    );
  }
}
