import 'package:flutter/material.dart';

import '../extensions/difficulty_extension.dart';
import '../extensions/habit_category_extension.dart';
import '../extensions/habit_frequency_extension.dart';
import '../models/difficulty.dart';
import '../models/habit.dart';
import '../models/habit_card_view_model.dart';

class HabitCardMapper {
  const HabitCardMapper();

  HabitCardViewModel map(Habit habit) {
    return HabitCardViewModel(
      id: habit.id,
      title: habit.title,
      description: habit.description,

      icon: IconData(
        habit.iconCodePoint,
        fontFamily: 'MaterialIcons',
      ),

      color: Color(habit.colorValue),

      category: habit.category,

      // TODO: Replace when Difficulty is stored in Habit.
      difficulty: Difficulty.medium,

      completedToday: habit.completedToday,
      currentStreak: habit.currentStreak,
      bestStreak: habit.bestStreak,
      xp: habit.xp,
      targetPerDay: habit.targetPerDay,
      progress: habit.completedToday ? 1.0 : 0.0,

      // TODO: Replace with actual duration when available.
      durationMinutes: 15,

      // Display labels
      categoryLabel: habit.category.label,
      frequencyLabel: habit.frequency.label,
      difficultyLabel: Difficulty.medium.label,
    );
  }

  List<HabitCardViewModel> mapList(List<Habit> habits) {
    return habits.map(map).toList();
  }
}
