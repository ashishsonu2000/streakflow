import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class CompleteHabitUseCase {
  CompleteHabitUseCase(this._repository);

  final HabitRepository _repository;

  Future<void> call(
      String habitId, {
        int durationMinutes = 0,
        String notes = '',
      }) async {
    // =========================================================
    // Load Habit
    // =========================================================

    final habit =
    await _repository.getById(habitId);

    if (habit == null) {
      throw Exception(
        'Habit not found.',
      );
    }

    // =========================================================
    // Today
    // =========================================================

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // =========================================================
    // Start Date
    // =========================================================

    final startDate = DateTime(
      habit.startDate.year,
      habit.startDate.month,
      habit.startDate.day,
    );

    if (today.isBefore(startDate)) {
      throw Exception(
        'This habit has not started yet.',
      );
    }

    // =========================================================
    // End Date
    // =========================================================

    if (habit.endDate != null) {
      final endDate = DateTime(
        habit.endDate!.year,
        habit.endDate!.month,
        habit.endDate!.day,
      );

      if (today.isAfter(endDate)) {
        throw Exception(
          'This habit has already ended.',
        );
      }
    }

    // =========================================================
    // Complete Habit
    // =========================================================

    await _repository.completeHabit(
      habitId,
      durationMinutes: durationMinutes,
      notes: notes,
    );
  }
}