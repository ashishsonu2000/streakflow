import 'package:flutter/foundation.dart';

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
    debugPrint(
      '========== FLOW 3: UpdateHabitUseCase ==========',
    );

    debugPrint(
      'UPDATING HABIT: ${request.title}',
    );

    debugPrint(
      'frequency: ${request.frequency}',
    );

    debugPrint(
      'weeklyDays: ${request.weeklyDays}',
    );

    debugPrint(
      'monthlyDay: ${request.monthlyDay}',
    );

    debugPrint(
      'startDate: ${request.startDate}',
    );

    debugPrint(
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

    debugPrint(
      '-----------------------------------------------',
    );

    debugPrint(
      'HABIT UPDATE',
    );

    debugPrint(
      'id: ${habit.id}',
    );

    debugPrint(
      'title: ${habit.title}',
    );

    debugPrint(
      'frequency: ${habit.frequency}',
    );

    debugPrint(
      'weeklyDays: ${habit.weeklyDays}',
    );

    debugPrint(
      'monthlyDay: ${habit.monthlyDay}',
    );

    debugPrint(
      'startDate: ${habit.startDate}',
    );

    debugPrint(
      'endDate: ${habit.endDate}',
    );

    debugPrint(
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

    debugPrint(
      'Habit updated successfully.',
    );

    // =========================================================
    // Schedule new reminder
    // =========================================================

    if (habit.reminderEnabled) {
      await _scheduleHabitReminder(
        habit,
      );

      debugPrint(
        'New reminder scheduled.',
      );
    } else {
      debugPrint(
        'Reminder disabled.',
      );
    }
  }
}