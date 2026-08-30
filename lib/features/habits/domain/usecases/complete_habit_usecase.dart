import '../models/habit.dart';
import '../repositories/habit_repository.dart';
import '../services/habit_schedule_service.dart';

class CompleteHabitUseCase {
  CompleteHabitUseCase(this._repository);

  final HabitRepository _repository;

  final HabitScheduleService _scheduleService =
  const HabitScheduleService();

  Future<void> call(
      String habitId, {
        DateTime? date,
        int durationMinutes = 0,
        String notes = '',
      }) async {
    // =========================================================
    // Load Habit
    // =========================================================

    final habit = await _repository.getById(habitId);

    if (habit == null) {
      throw Exception('Habit not found.');
    }

    // =========================================================
    // Selected Date
    // =========================================================

    final selectedDate = date ?? DateTime.now();

    final selectedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    // =========================================================
    // Start Date
    // =========================================================

    final start = habit.startDate;

    if (start != null) {
      final startDate = DateTime(
        start.year,
        start.month,
        start.day,
      );

      if (selectedDay.isBefore(startDate)) {
        throw Exception(
          'This habit has not started yet.',
        );
      }
    }

    // =========================================================
    // End Date
    // =========================================================

    final end = habit.endDate;

    if (end != null) {
      final endDate = DateTime(
        end.year,
        end.month,
        end.day,
      );

      if (selectedDay.isAfter(endDate)) {
        throw Exception(
          'This habit has already ended.',
        );
      }
    }

    // =========================================================
    // Recurrence / Schedule Validation
    // =========================================================

    final isScheduled =
    _scheduleService.isScheduledForDate(
      habit,
      selectedDay,
    );

    if (!isScheduled) {
      throw Exception(
        'This habit is not scheduled for this date.',
      );
    }

    // =========================================================
    // Complete Habit
    // =========================================================

    await _repository.completeHabit(
      habitId,
      date: selectedDay,
      durationMinutes: durationMinutes,
      notes: notes,
    );
  }
}