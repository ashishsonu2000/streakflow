import 'package:streak_calculator_flutter/core/utils/app_logger.dart';

import '../../../notifications/domain/usecases/cancel_habit_reminder_usecase.dart';
import '../repositories/habit_repository.dart';

class DeleteHabitUseCase {
  DeleteHabitUseCase(
    this._repository, {
    CancelHabitReminderUseCase? cancelReminders,
  }) : _cancelReminders = cancelReminders;

  final HabitRepository _repository;

  /// Deleted habits must not keep sending reminders.
  final CancelHabitReminderUseCase? _cancelReminders;

  Future<void> call(String habitId) async {
    await _repository.delete(habitId);

    try {
      await _cancelReminders?.byId(habitId);
    } catch (error) {
      // Never block deletion because of a notification error.
      AppLogger.log('Delete: reminder cancel failed: $error');
    }
  }
}
