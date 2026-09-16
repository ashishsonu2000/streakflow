import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

import '../../../habits/domain/models/habit.dart';
import '../services/notification_service.dart';

class ScheduleHabitReminderUseCase {
  const ScheduleHabitReminderUseCase(
      this._notificationService,
      );

  final NotificationService _notificationService;

  Future<void> call(Habit habit) async {

    AppLogger.log('========================================');
    AppLogger.log('SCHEDULE USE CASE START');
    AppLogger.log('Habit       : ${habit.title}');
    AppLogger.log('Habit ID    : ${habit.id}');
    AppLogger.log('Reminder    : ${habit.reminderEnabled}');
    AppLogger.log('Hour        : ${habit.reminderHour}');
    AppLogger.log('Minute      : ${habit.reminderMinute}');
    AppLogger.log('Start Date  : ${habit.startDate}');
    AppLogger.log('End Date    : ${habit.endDate}');
    AppLogger.log('========================================');

    if (!habit.reminderEnabled) {
      AppLogger.log('SCHEDULE: reminder disabled -> RETURN');
      return;
    }

    final hour = habit.reminderHour;
    final minute = habit.reminderMinute;

    if (hour == null || minute == null) {
      AppLogger.log(
        'SCHEDULE: reminder time is NULL -> RETURN',
      );
      return;
    }

    if (hour < 0 || hour > 23) {
      AppLogger.log(
        'SCHEDULE: invalid hour $hour -> RETURN',
      );
      return;
    }

    if (minute < 0 || minute > 59) {
      AppLogger.log(
        'SCHEDULE: invalid minute $minute -> RETURN',
      );
      return;
    }

    AppLogger.log(
      'SCHEDULE: calling NotificationService.scheduleHabitReminder()',
    );

    try {
      await _notificationService.scheduleHabitReminder(
        habitId: habit.id,
        habitTitle: habit.title,
        hour: hour,
        minute: minute,
        startDate: habit.startDate,
        endDate: habit.endDate,
      );

      AppLogger.log(
        'SCHEDULE: NotificationService completed SUCCESSFULLY',
      );
    } catch (e, stackTrace) {
      AppLogger.log(
        'SCHEDULE: NotificationService FAILED: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}