import '../../../habits/domain/models/habit.dart';

import '../services/notification_service.dart';

class CancelHabitReminderUseCase {
  const CancelHabitReminderUseCase(
      this._notificationService,
      );

  final NotificationService _notificationService;

  Future<void> call(
      Habit habit,
      ) async {
    await _notificationService.cancelHabitReminder(
      habit.id,
    );
  }
}