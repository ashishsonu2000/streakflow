import 'package:streak_calculator_flutter/core/utils/app_logger.dart';

import '../../../notifications/domain/usecases/schedule_habit_reminder_usecase.dart';
import '../repositories/habit_repository.dart';
import '../services/habit_limit_guard.dart';

/// Unarchives a habit, making it active again.
class RestoreHabitUseCase {
  RestoreHabitUseCase(
    this._repository, {
    HabitLimitGuard? limitGuard,
    ScheduleHabitReminderUseCase? scheduleReminders,
  })  : _limitGuard = limitGuard,
        _scheduleReminders = scheduleReminders;

  final HabitRepository _repository;

  /// Free plan active-habit limit. Throws HabitLimitReachedException.
  final HabitLimitGuard? _limitGuard;

  /// Reminders were cancelled on archive; schedule them again.
  final ScheduleHabitReminderUseCase? _scheduleReminders;

  Future<void> call(String habitId) async {
    await _limitGuard?.ensureCanAddActiveHabit();

    await _repository.restore(habitId);

    final schedule = _scheduleReminders;
    if (schedule == null) {
      return;
    }

    try {
      final habit = await _repository.getById(habitId);
      if (habit != null) {
        await schedule(habit);
      }
    } catch (error) {
      // Never block unarchiving because of a notification error.
      AppLogger.log('Restore: reminder schedule failed: $error');
    }
  }
}
