import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/services/notification_service.dart';

void main() {
  test('reminders are on until the user switches them off', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await NotificationService.remindersSwitchedOn(), isTrue);
  });

  test('the in-app switch is respected', () async {
    SharedPreferences.setMockInitialValues({
      NotificationService.remindersEnabledKey: false,
    });

    expect(await NotificationService.remindersSwitchedOn(), isFalse);

    SharedPreferences.setMockInitialValues({
      NotificationService.remindersEnabledKey: true,
    });

    expect(await NotificationService.remindersSwitchedOn(), isTrue);
  });
}
