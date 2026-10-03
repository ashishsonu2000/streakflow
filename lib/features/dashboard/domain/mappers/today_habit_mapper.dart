import 'package:flutter/material.dart';

import '../../../../core/ui/icons/habit_icon_resolver.dart';
import '../../../habits/domain/models/habit.dart';
import '../models/today_habit_view_model.dart';

class TodayHabitMapper {
  const TodayHabitMapper();

  List<TodayHabitViewModel> map(
    List<Habit> habits,
  ) {
    return habits
        .where((habit) => !habit.archived)
        .map(
          (habit) => TodayHabitViewModel(
            id: habit.id,
            title: habit.title,
            icon: habitIconFromCodePoint(habit.iconCodePoint),
            color: Color(habit.colorValue),
            completed: habit.completedToday,
            currentStreak: habit.currentStreak,
            durationMinutes: habit.estimatedDurationMinutes,
            target: habit.targetPerDay,
            category: habit.category.name,
            difficulty: habit.difficulty.name,
          ),
        )
        .toList(growable: false);
  }
}
