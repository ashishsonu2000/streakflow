import '../domain/models/habit.dart';
import '../domain/models/update_habit_request.dart';
import '../domain/repositories/habit_repository.dart';

class UpdateHabitUseCase {
  UpdateHabitUseCase(this._repository);

  final HabitRepository _repository;

  Future<void> call(UpdateHabitRequest request) async {
    final habit = Habit(
      id: request.id,
      title: request.title,
      description: request.description,
      category: request.category,
      frequency: request.frequency,
      iconCodePoint: request.iconCodePoint,
      colorValue: request.colorValue,
      targetPerDay: request.targetPerDay,
      currentStreak: request.currentStreak,
      bestStreak: request.bestStreak,
      totalCompleted: request.totalCompleted,
      xp: request.xp,
      reminderEnabled: request.reminderEnabled,
      reminderHour: request.reminderHour,
      reminderMinute: request.reminderMinute,
      archived: request.archived,
      createdAt: request.createdAt,
      updatedAt: DateTime.now(),
      lastCompletedDate: request.lastCompletedDate,
      completedToday: request.completedToday,
    );

    await _repository.update(habit);
  }
}
