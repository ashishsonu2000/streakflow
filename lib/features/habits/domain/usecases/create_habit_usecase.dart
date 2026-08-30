import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../notifications/domain/usecases/schedule_habit_reminder_usecase.dart';

import '../models/create_habit_request.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class CreateHabitUseCase {
  CreateHabitUseCase(
      this._repository,
      this._scheduleHabitReminder,
      );

  final HabitRepository _repository;

  final ScheduleHabitReminderUseCase
  _scheduleHabitReminder;

  final Uuid _uuid = const Uuid();

  Future<void> call(
      CreateHabitRequest request,
      ) async {
    debugPrint(
      '========== FLOW 3: CreateHabitUseCase ==========',
    );

    debugPrint(
      'FLOW 3: title = ${request.title}',
    );

    debugPrint(
      'FLOW 3: frequency = ${request.frequency}',
    );

    debugPrint(
      'FLOW 3: weeklyDays = ${request.weeklyDays}',
    );

    debugPrint(
      'FLOW 3: monthlyDay = ${request.monthlyDay}',
    );

    debugPrint(
      'FLOW 3: reminderEnabled = '
          '${request.reminderEnabled}',
    );

    debugPrint(
      'FLOW 3: reminderTime = '
          '${request.reminderHour}:'
          '${request.reminderMinute}',
    );

    final now = DateTime.now();

    // =========================================================
    // Create Habit
    // =========================================================

    final habit = Habit(
      id: _uuid.v4(),

      title:
      request.title.trim(),

      description:
      request.description.trim(),

      category:
      request.category,

      frequency:
      request.frequency,

      iconCodePoint:
      request.iconCodePoint,

      colorValue:
      request.colorValue,

      targetPerDay:
      request.targetPerDay,

      // =======================================================
      // Recurrence
      // =======================================================

      weeklyDays:
      List<int>.from(
        request.weeklyDays,
      ),

      monthlyDay:
      request.monthlyDay,

      // =======================================================
      // Reminder
      // =======================================================

      reminderEnabled:
      request.reminderEnabled,

      reminderHour:
      request.reminderHour,

      reminderMinute:
      request.reminderMinute,

      // =======================================================
      // Schedule
      // =======================================================

      startDate:
      request.startDate,

      endDate:
      request.endDate,

      // =======================================================
      // Progress
      // =======================================================

      currentStreak: 0,

      bestStreak: 0,

      totalCompleted: 0,

      xp: 0,

      // =======================================================
      // Status
      // =======================================================

      archived: false,

      createdAt:
      now,

      updatedAt:
      now,

      lastCompletedDate:
      null,

      completedToday:
      false,
    );

    debugPrint(
      '-----------------------------------------------',
    );

    debugPrint(
      'Saving habit: ${habit.title}',
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
    // Save
    // =========================================================

    await _repository.save(
      habit,
    );

    debugPrint(
      'Habit saved successfully: ${habit.id}',
    );

    // =========================================================
    // Reminder
    // =========================================================

    if (habit.reminderEnabled) {
      debugPrint(
        'Reminder ENABLED - '
            'calling ScheduleHabitReminderUseCase',
      );

      await _scheduleHabitReminder(
        habit,
      );

      debugPrint(
        'ScheduleHabitReminderUseCase completed',
      );
    } else {
      debugPrint(
        'Reminder DISABLED - '
            'notification not scheduled',
      );
    }
  }
}