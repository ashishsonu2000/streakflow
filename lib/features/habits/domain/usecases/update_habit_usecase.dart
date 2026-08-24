import 'package:flutter/cupertino.dart';

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

      startDate:
      request.startDate,
      endDate:
      request.endDate,

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

    // Always cancel the old reminder first.
    await _cancelHabitReminder(
      habit,
    );
    debugPrint(
      'UPDATING HABIT: '
          '${habit.title} | '
          'start=${habit.startDate} | '
          'end=${habit.endDate}',
    );
    await _repository.update(habit);

    // Schedule the new reminder if enabled.
    if (habit.reminderEnabled) {
      await _scheduleHabitReminder(habit);
    }
  }
}