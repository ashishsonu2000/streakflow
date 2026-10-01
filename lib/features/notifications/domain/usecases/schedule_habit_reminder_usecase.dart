import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/entitlements/premium_config.dart';
import '../../../habits/domain/models/habit.dart';
import '../services/notification_service.dart';
import '../services/reminder_schedule.dart';

class ScheduleHabitReminderUseCase {
  const ScheduleHabitReminderUseCase(
      this._notificationService, {
      int Function()? maxRemindersPerHabit,
      }) : _maxRemindersPerHabit = maxRemindersPerHabit;

  final NotificationService _notificationService;

  /// Reminders allowed per habit for the current plan (Free: 1,
  /// Premium: more). Extra reminder times above the limit are kept on
  /// the habit but not scheduled.
  final int Function()? _maxRemindersPerHabit;

  Future<void> call(Habit habit) async {
    final maxReminders = _maxRemindersPerHabit?.call() ??
        PremiumConfig.freeRemindersPerHabit;

    AppLogger.log('========================================');
    AppLogger.log('SCHEDULE USE CASE START');
    AppLogger.log('Habit       : ${habit.title}');
    AppLogger.log('Habit ID    : ${habit.id}');
    AppLogger.log('Reminder    : ${habit.reminderEnabled}');
    AppLogger.log('Hour        : ${habit.reminderHour}');
    AppLogger.log('Minute      : ${habit.reminderMinute}');
    AppLogger.log('Extra times : ${habit.additionalReminderMinutes}');
    AppLogger.log('Max allowed : $maxReminders');
    AppLogger.log('Start Date  : ${habit.startDate}');
    AppLogger.log('End Date    : ${habit.endDate}');
    AppLogger.log('========================================');

    final times = ReminderTimes.resolve(
      habit,
      maxReminders: maxReminders,
    );

    if (times.isEmpty) {
      AppLogger.log(
        'SCHEDULE: reminder disabled or invalid time -> RETURN',
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
        reminderMinutes: times,
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
