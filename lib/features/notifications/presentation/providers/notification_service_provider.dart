import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/services/notification_service.dart';

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
      'notifications_enabled';

  @override
  NotificationState build() {
    return const NotificationState();
  }

  /// Loads the saved notification preference.
  Future<void> initialize() async {
    final preferences =
    await SharedPreferences.getInstance();

    final enabled =
        preferences.getBool(_enabledKey) ?? false;

    state = state.copyWith(
      enabled: enabled,
      isLoading: false,
    );
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