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
    await byId(habit.id);
  }

  /// Cancels every reminder of the habit with [habitId].
  Future<void> byId(String habitId) {
    return _notificationService.cancelHabitReminder(habitId);
  }
}