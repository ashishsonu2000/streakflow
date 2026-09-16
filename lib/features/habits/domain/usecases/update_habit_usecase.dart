import 'package:streak_calculator_flutter/core/utils/app_logger.dart';

import '../../../notifications/domain/usecases/cancel_habit_reminder_usecase.dart';
import '../../../notifications/domain/usecases/schedule_habit_reminder_usecase.dart';

import '../models/habit.dart';
import '../models/update_habit_request.dart';
import '../repositories/habit_repository.dart';

class UpdateHabitUseCase {
  UpdateHabitUseCase(
      this._repository,
      this._scheduleHabitReminder,
      this._cancelHabitReminder,
      );

  final HabitRepository _repository;

  final ScheduleHabitReminderUseCase
  _scheduleHabitReminder;

  final CancelHabitReminderUseCase
  _cancelHabitReminder;

  Future<void> call(
      UpdateHabitRequest request,
      ) async {
    AppLogger.log(
      '========== FLOW 3: UpdateHabitUseCase ==========',
    );

    AppLogger.log(
      'UPDATING HABIT: ${request.title}',
    );

    AppLogger.log(
      'frequency: ${request.frequency}',
    );

    AppLogger.log(
      'weeklyDays: ${request.weeklyDays}',
    );

    AppLogger.log(
      'monthlyDay: ${request.monthlyDay}',
    );

    AppLogger.log(
      'startDate: ${request.startDate}',
    );

    AppLogger.log(
      'endDate: ${request.endDate}',
    );

    // =========================================================
    // Build updated domain model
    // =========================================================

    final habit = Habit(
      id: request.id,
      title: request.title,
      description: request.description,
      category: request.category,
      frequency: request.frequency,
      iconCodePoint: request.iconCodePoint,
      colorValue: request.colorValue,
      targetPerDay: request.targetPerDay,

      reminderEnabled:
      request.reminderEnabled,
      reminderHour:
      request.reminderHour,
      reminderMinute:
      request.reminderMinute,

      // Schedule
      startDate:
      request.startDate,
      endDate:
      request.endDate,

      // Recurrence
      weeklyDays:
      List<int>.from(
        request.weeklyDays,
      ),
      monthlyDay:
      request.monthlyDay,

      currentStreak:
      request.currentStreak,
      bestStreak:
      request.bestStreak,
      totalCompleted:
      request.totalCompleted,
      xp:
      request.xp,

      archived:
      request.archived,

      createdAt:
      request.createdAt,

      updatedAt:
      DateTime.now(),

      lastCompletedDate:
      request.lastCompletedDate,

      completedToday:
      request.completedToday,
    );

    AppLogger.log(
      '-----------------------------------------------',
    );

    AppLogger.log(
      'HABIT UPDATE',
    );

    AppLogger.log(
      'id: ${habit.id}',
    );

    AppLogger.log(
      'title: ${habit.title}',
    );

    AppLogger.log(
      'frequency: ${habit.frequency}',
    );

    AppLogger.log(
      'weeklyDays: ${habit.weeklyDays}',
    );

    AppLogger.log(
      'monthlyDay: ${habit.monthlyDay}',
    );

    AppLogger.log(
      'startDate: ${habit.startDate}',
    );

    AppLogger.log(
      'endDate: ${habit.endDate}',
    );

    AppLogger.log(
      '-----------------------------------------------',
    );

    // =========================================================
    // Cancel old reminder
    // =========================================================

    await _cancelHabitReminder(
      habit,
    );

    // =========================================================
    // Persist updated habit
    // =========================================================

    await _repository.update(
      habit,
    );

    AppLogger.log(
      'Habit updated successfully.',
    );

    // =========================================================
    // Schedule new reminder
    // =========================================================

    if (habit.reminderEnabled) {
      await _scheduleHabitReminder(
        habit,
      );

      AppLogger.log(
        'New reminder scheduled.',
      );
    } else {
      AppLogger.log(
        'Reminder disabled.',
      );
    }
  }
}