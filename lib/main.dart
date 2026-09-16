import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'features/notifications/presentation/providers/notification_service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.log('========================================');
  AppLogger.log('APP START');
  AppLogger.log('========================================');

  // Create a single ProviderContainer for the entire application.
  final container = ProviderContainer();

  try {
    // ------------------------------------------------------------
    // Notification Service
    // ------------------------------------------------------------

    final notificationService =
    container.read(notificationServiceProvider);

    AppLogger.log('NotificationService obtained');

    await notificationService.initialize();

    AppLogger.log('NotificationService.initialize() completed');

    // ------------------------------------------------------------
    // Notification Provider
    // ------------------------------------------------------------

    final notificationProviderNotifier =
    container.read(notificationProvider.notifier);

    AppLogger.log('NotificationProvider obtained');

    await notificationProviderNotifier.initialize();

    AppLogger.log('NotificationProvider.initialize() completed');

    AppLogger.log('========================================');
    AppLogger.log('NOTIFICATION STARTUP COMPLETED');
    AppLogger.log('========================================');

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
    AppLogger.log('========================================');
    AppLogger.log('STARTUP ERROR');
    AppLogger.log('$error');
    AppLogger.log('$stackTrace');
    AppLogger.log('========================================');

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