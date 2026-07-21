import 'package:flutter/material.dart';
import 'package:streak_calculator_flutter/core/extensions/habit_extensions.dart';

import 'difficulty.dart';
import 'habit.dart';
import 'habit_category.dart';

import '../enums/habit_frequency.dart';

class HabitCardViewModel {
  const HabitCardViewModel({
    required this.habit,
  });

  final Habit habit;

  String get id => habit.id;

  String get title => habit.title;

  String get description => habit.description;

  IconData get icon => habit.icon;

  Color get color => habit.color;

  HabitCategory get category => habit.category;

  Difficulty get difficulty => habit.difficulty;

  HabitFrequency get frequency => habit.frequency;

  bool get completedToday => habit.completedToday;

  int get currentStreak => habit.currentStreak;

  int get bestStreak => habit.bestStreak;

  int get xp => habit.xp;

  int get targetPerDay => habit.targetPerDay;

  double get progress => completedToday ? 1.0 : 0.0;

  int get durationMinutes => habit.estimatedDurationMinutes;
}
