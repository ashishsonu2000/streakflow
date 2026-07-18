import 'package:flutter/widgets.dart';

import 'difficulty.dart';
import 'habit_category.dart';

class HabitCardViewModel {
  const HabitCardViewModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    required this.difficulty,
    required this.completedToday,
    required this.currentStreak,
    required this.bestStreak,
    required this.xp,
    required this.targetPerDay,
    required this.progress,
    required this.durationMinutes,
    required this.categoryLabel,
    required this.frequencyLabel,
    required this.difficultyLabel,
  });

  final String id;

  final String title;

  final String description;

  final IconData icon;

  final Color color;

  final HabitCategory category;

  final Difficulty difficulty;

  final bool completedToday;

  final int currentStreak;

  final int bestStreak;

  final int xp;

  final int targetPerDay;

  final double progress;

  final int durationMinutes;

  final String categoryLabel;
  final String frequencyLabel;
  final String difficultyLabel;
}
