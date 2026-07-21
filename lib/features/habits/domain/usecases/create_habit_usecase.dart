import 'package:uuid/uuid.dart';

import '../models/create_habit_request.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class CreateHabitUseCase {
  CreateHabitUseCase(this._repository);

  final HabitRepository _repository;

  final Uuid _uuid = const Uuid();

  Future<void> call(
    CreateHabitRequest request,
  ) async {
    final now = DateTime.now();

    final habit = Habit(
      id: _uuid.v4(),
      title: request.title.trim(),
      description: request.description.trim(),
      category: request.category,
      frequency: request.frequency,
      iconCodePoint: request.iconCodePoint,
      colorValue: request.colorValue,
      targetPerDay: request.targetPerDay,
      reminderEnabled: request.reminderEnabled,
      reminderHour: request.reminderHour,
      reminderMinute: request.reminderMinute,
      currentStreak: 0,
      bestStreak: 0,
      totalCompleted: 0,
      xp: 0,
      archived: false,
      createdAt: now,
      updatedAt: now,
      lastCompletedDate: null,
    );

    await _repository.save(habit);
  }
}
