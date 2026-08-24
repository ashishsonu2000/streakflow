import 'package:flutter/foundation.dart';

import '../../../habits/domain/models/habit.dart';
import '../services/notification_service.dart';

class ScheduleHabitReminderUseCase {
  const ScheduleHabitReminderUseCase(
      this._notificationService,
      );

  final NotificationService _notificationService;

  Future<void> call(Habit habit) async {

    debugPrint('========================================');
    debugPrint('SCHEDULE USE CASE START');
    debugPrint('Habit       : ${habit.title}');
    debugPrint('Habit ID    : ${habit.id}');
    debugPrint('Reminder    : ${habit.reminderEnabled}');
    debugPrint('Hour        : ${habit.reminderHour}');
    debugPrint('Minute      : ${habit.reminderMinute}');
    debugPrint('Start Date  : ${habit.startDate}');
    debugPrint('End Date    : ${habit.endDate}');
    debugPrint('========================================');

    if (!habit.reminderEnabled) {
      debugPrint('SCHEDULE: reminder disabled -> RETURN');
      return;
    }

    final hour = habit.reminderHour;
    final minute = habit.reminderMinute;

    if (hour == null || minute == null) {
      debugPrint(
        'SCHEDULE: reminder time is NULL -> RETURN',
      );
      return;
    }

    if (hour < 0 || hour > 23) {
      debugPrint(
        'SCHEDULE: invalid hour $hour -> RETURN',
      );
      return;
    }

    if (minute < 0 || minute > 59) {
      debugPrint(
        'SCHEDULE: invalid minute $minute -> RETURN',
      );
      return;
    }

    debugPrint(
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

      debugPrint(
        'SCHEDULE: NotificationService completed SUCCESSFULLY',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'SCHEDULE: NotificationService FAILED: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}