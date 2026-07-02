import 'package:flutter/material.dart';

import '../../habits/domain/models/habit.dart';
import 'models/habit_summary.dart';

class HabitSummaryMapper {
  const HabitSummaryMapper();

  HabitSummary toSummary(Habit habit) {
    return HabitSummary(
      id: habit.id,
      title: habit.title,
      subtitle: habit.description,
      icon: IconData(
        habit.iconCodePoint,
        fontFamily: 'MaterialIcons',
      ),
      color: Color(habit.colorValue),
      completed: false,
      points: habit.xp,
      streak: habit.currentStreak,
    );
  }
}
