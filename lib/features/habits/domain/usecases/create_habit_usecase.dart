import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
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
    AppLogger.log(
      '========== FLOW 3: CreateHabitUseCase ==========',
    );

    AppLogger.log(
      'FLOW 3: title = ${request.title}',
    );

    AppLogger.log(
      'FLOW 3: frequency = ${request.frequency}',
    );

    AppLogger.log(
      'FLOW 3: weeklyDays = ${request.weeklyDays}',
    );

    AppLogger.log(
      'FLOW 3: monthlyDay = ${request.monthlyDay}',
    );

    AppLogger.log(
      'FLOW 3: reminderEnabled = '
          '${request.reminderEnabled}',
    );

    AppLogger.log(
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

    AppLogger.log(
      '-----------------------------------------------',
    );

    AppLogger.log(
      'Saving habit: ${habit.title}',
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
    // Save
    // =========================================================

    await _repository.save(
      habit,
    );

    AppLogger.log(
      'Habit saved successfully: ${habit.id}',
    );

    // =========================================================
    // Reminder
    // =========================================================

    if (habit.reminderEnabled) {
      AppLogger.log(
        'Reminder ENABLED - '
            'calling ScheduleHabitReminderUseCase',
      );

      await _scheduleHabitReminder(
        habit,
      );

      AppLogger.log(
        'ScheduleHabitReminderUseCase completed',
      );
    } else {
      AppLogger.log(
        'Reminder DISABLED - '
            'notification not scheduled',
      );
    }
  }
}