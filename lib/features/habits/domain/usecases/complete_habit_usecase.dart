import '../models/habit.dart';
import '../repositories/habit_repository.dart';
import '../services/habit_schedule_service.dart';

class CompleteHabitUseCase {
  CompleteHabitUseCase(
      this._repository,
      );

  final HabitRepository _repository;

  static const HabitScheduleService _scheduleService =
  HabitScheduleService();

  Future<void> call(
      String habitId, {
        DateTime? date,
        int durationMinutes = 0,
        String notes = '',
      }) async {
    // =========================================================
    // LOAD HABIT
    // =========================================================

    final habit =
    await _repository.getById(habitId);

    if (habit == null) {
      throw Exception(
        'Habit not found.',
      );
    }

    // =========================================================
    // SELECTED DATE
    // =========================================================

    final selectedDate =
        date ?? DateTime.now();

    final selectedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    // =========================================================
    // HABIT START DATE
    // =========================================================

    final startDate = DateTime(
      habit.startDate.year,
      habit.startDate.month,
      habit.startDate.day,
    );

    if (selectedDay.isBefore(startDate)) {
      throw Exception(
        'This habit has not started yet.',
      );
    }

    // =========================================================
    // HABIT END DATE
    // =========================================================

    final endDate = habit.endDate;

    if (endDate != null) {
      final normalizedEndDate = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
      );

      if (selectedDay.isAfter(
        normalizedEndDate,
      )) {
        throw Exception(
          'This habit has already ended.',
        );
      }
    }

    // =========================================================
    // SCHEDULE VALIDATION
    //
    // Only after start/end validation do we check whether the
    // habit is scheduled for the selected date.
    //
    // Daily   -> every active day
    // Weekly  -> configured weeklyDays
    // Monthly -> configured monthlyDay
    // Custom  -> handled by HabitScheduleService
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
    // COMPLETE HABIT
    // =========================================================

    await _repository.completeHabit(
      habitId,
      date: selectedDay,
      durationMinutes:
      durationMinutes,
      notes: notes,
    );
  }
}