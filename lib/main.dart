import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'features/notifications/presentation/providers/notification_service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('========================================');
  debugPrint('APP START');
  debugPrint('========================================');

  // Create a single ProviderContainer for the entire application.
  final container = ProviderContainer();

  try {
    // ------------------------------------------------------------
    // Notification Service
    // ------------------------------------------------------------

    final notificationService =
    container.read(notificationServiceProvider);

    debugPrint('NotificationService obtained');

    await notificationService.initialize();

    debugPrint('NotificationService.initialize() completed');

    // ------------------------------------------------------------
    // Notification Provider
    // ------------------------------------------------------------

    final notificationProviderNotifier =
    container.read(notificationProvider.notifier);

    debugPrint('NotificationProvider obtained');

    await notificationProviderNotifier.initialize();

    debugPrint('NotificationProvider.initialize() completed');

    debugPrint('========================================');
    debugPrint('NOTIFICATION STARTUP COMPLETED');
    debugPrint('========================================');

    // ------------------------------------------------------------
    // Start Flutter application
    // ------------------------------------------------------------

    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const StreakCalculatorApp(),
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('========================================');
    debugPrint('STARTUP ERROR');
    debugPrint('$error');
    debugPrint('$stackTrace');
    debugPrint('========================================');

    // Still start the application if notification initialization
    // fails. The app should not become unusable just because
    // notifications could not initialize.
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const StreakCalculatorApp(),
      ),
    );
  }
}