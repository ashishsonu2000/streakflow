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
    // Selected Date
    // =========================================================

    final selectedDate =
        date ?? DateTime.now();

    final selectedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    // =========================================================
    // Schedule Validation
    //
    // HabitScheduleService handles:
    //
    // Daily   -> every active day
    // Weekly  -> weeklyDays
    // Monthly -> monthlyDay
    // Start   -> startDate
    // End     -> endDate
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