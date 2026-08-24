import 'package:uuid/uuid.dart';

import '../../../habits/domain/enums/habit_frequency.dart';
import '../../../habits/domain/models/difficulty.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_category.dart';
import '../../../habits/domain/repositories/habit_repository.dart';

import '../models/suggested_habit.dart';

class CreateSuggestedHabitUseCase {
  const CreateSuggestedHabitUseCase(
      this._repository,
      );

  final HabitRepository _repository;

  Future<void> execute(
      SuggestedHabit suggestion,
      ) async {
    final now = DateTime.now();

    final startDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final habit = Habit(
      id: const Uuid().v4(),

      title: suggestion.title,
      description: suggestion.description,

      category: _mapCategory(
        suggestion.category,
      ),

      frequency: HabitFrequency.daily,

      // =====================================================
      // Schedule
      // =====================================================

      startDate: startDate,
      endDate: null,

      // =====================================================
      // Defaults
      // =====================================================

      createdAt: now,
      updatedAt: now,

      difficulty: Difficulty.easy,
      xpReward: 5,
      targetPerDay: 1,

      reminderEnabled: false,

      currentStreak: 0,
      bestStreak: 0,
      totalCompleted: 0,
      xp: 0,

      archived: false,

      lastCompletedDate: null,
      completedToday: false,
    );

    await _repository.save(
      habit,
    );
  }

  HabitCategory _mapCategory(
      String category,
      ) {
    switch (category) {
      case 'Health':
        return HabitCategory.health;

      case 'Fitness':
        return HabitCategory.fitness;

      case 'Productivity':
        return HabitCategory.personal;

      case 'Mindfulness':
        return HabitCategory.personal;

      default:
        return HabitCategory.personal;
    }
  }
}