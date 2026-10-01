import 'package:streak_calculator_flutter/core/utils/app_logger.dart';

import '../../../notifications/domain/usecases/cancel_habit_reminder_usecase.dart';
import '../repositories/habit_repository.dart';

class ArchiveHabitUseCase {
  ArchiveHabitUseCase(
    this._repository, {
    CancelHabitReminderUseCase? cancelReminders,
  }) : _cancelReminders = cancelReminders;

  final HabitRepository _repository;

  /// Archived habits must not keep sending reminders.
  final CancelHabitReminderUseCase? _cancelReminders;

  Future<void> call(String habitId) async {
    await _repository.archive(habitId);

    try {
      await _cancelReminders?.byId(habitId);
    } catch (error) {
      // Never block archiving because of a notification error.
      AppLogger.log('Archive: reminder cancel failed: $error');
    }
  }
}
