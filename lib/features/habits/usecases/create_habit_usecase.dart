import 'package:uuid/uuid.dart';

import '../data/entities/habit_frequency.dart';
import '../domain/models/habit.dart';
import '../domain/models/habit_category.dart';
import '../domain/repositories/habit_repository.dart';

class CreateHabitUseCase {
  CreateHabitUseCase(this._repository);

  final HabitRepository _repository;

  final Uuid _uuid = const Uuid();

  Future<void> call({
    required String title,
    String description = '',
    HabitCategory category = HabitCategory.personal,
    HabitFrequency frequency = HabitFrequency.daily,
    int iconCodePoint = 0,
    int colorValue = 0,
    int targetPerDay = 1,
    bool reminderEnabled = false,
    int? reminderHour,
    int? reminderMinute,
  }) async {
    final now = DateTime.now();

    final habit = Habit(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      category: category,
      frequency: frequency,
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      targetPerDay: targetPerDay,
      currentStreak: 0,
      bestStreak: 0,
      totalCompleted: 0,
      xp: 0,
      reminderEnabled: reminderEnabled,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      archived: false,
      createdAt: now,
      updatedAt: now,
      lastCompletedDate: null,
    );

    await _repository.save(habit);
  }
}
