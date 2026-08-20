import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'features/notifications/presentation/providers/notification_service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  final notificationService =
  container.read(
    notificationServiceProvider,
  );

  await notificationService.initialize();

  await container
      .read(notificationProvider.notifier)
      .initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const StreakCalculatorApp(),
    ),
  );
}