import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../habits/presentation/providers/habit_repository_provider.dart';
import '../../domain/services/notification_service.dart';
import 'notification_usecase_provider.dart';
import 'reminder_entitlement_sync.dart';

final notificationServiceProvider =
Provider<NotificationService>((ref) {
  AppLogger.log(
    '🔔 Creating NotificationService instance',
  );
  return NotificationService();
});

class NotificationState {
  const NotificationState({
    this.enabled = false,
    this.isLoading = false,
  });

  final bool enabled;
  final bool isLoading;

  NotificationState copyWith({
    bool? enabled,
    bool? isLoading,
  }) {
    return NotificationState(
      enabled: enabled ?? this.enabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class NotificationNotifier
    extends Notifier<NotificationState> {
  static const String _enabledKey =
      NotificationService.remindersEnabledKey;

  @override
  NotificationState build() {
    return const NotificationState();
  }

  /// Loads the reminders switch. Reminders are on when the user
  /// hasn't switched them off in the app AND Android allows the app
  /// to post notifications - the same rule the scheduler follows.
  Future<void> initialize() async {
    final switchedOn =
    await NotificationService.remindersSwitchedOn();

    final permitted =
    await ref.read(notificationServiceProvider).isPermissionGranted();

    state = state.copyWith(
      enabled: switchedOn && permitted,
      isLoading: false,
    );
  }

  /// Schedules every habit that has a reminder (after switching
  /// reminders back on; switching off cancelled them all).
  Future<void> _rescheduleAll() async {
    final habits =
    await ref.read(habitRepositoryProvider).getAllForCalendar();

    final schedule =
    ref.read(scheduleHabitReminderUseCaseProvider);

    for (final habit in habits.where(hasReminder)) {
      await schedule(habit);
    }
  }

  /// Enables or disables habit notifications.
  Future<bool> setEnabled(
      bool enabled,
      ) async {
    state = state.copyWith(
      isLoading: true,
    );

    try {
      final service =
      ref.read(notificationServiceProvider);

      if (enabled) {
        final granted =
        await service.requestPermission();

        if (!granted) {
          state = state.copyWith(
            enabled: false,
            isLoading: false,
          );

          return false;
        }
      } else {
        await service.cancelAll();
      }

      final preferences =
      await SharedPreferences.getInstance();

      await preferences.setBool(
        _enabledKey,
        enabled,
      );

      if (enabled) {
        await _rescheduleAll();
      }

      state = state.copyWith(
        enabled: enabled,
        isLoading: false,
      );

      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
      );

      return false;
    }
  }

  /// Sends an immediate test notification.
  Future<bool> sendTestNotification() async {
    if (!state.enabled) {
      return false;
    }

    try {
      final service =
      ref.read(notificationServiceProvider);

      await service.showNow();

      return true;
    } catch (_) {
      return false;
    }
  }
}

final notificationProvider =
NotifierProvider<
    NotificationNotifier,
    NotificationState>(
  NotificationNotifier.new,
);