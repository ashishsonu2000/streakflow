import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'features/notifications/presentation/providers/notification_service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('========================================');
  debugPrint('APP START');
  debugPrint('========================================');

  final container = ProviderContainer();

  final notificationService =
  container.read(notificationServiceProvider);

  debugPrint('NotificationService obtained');

  await notificationService.initialize();
 // await notificationService.debugNotificationStatus();

  debugPrint('NotificationService.initialize() completed');

  final notificationProviderNotifier =
  container.read(notificationProvider.notifier);

  debugPrint('NotificationProvider obtained');

  await notificationProviderNotifier.initialize();

  debugPrint('NotificationProvider.initialize() completed');

  debugPrint('========================================');
  debugPrint('NOTIFICATION STARTUP COMPLETED');
  debugPrint('========================================');

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const StreakCalculatorApp(),
    ),
  );
}