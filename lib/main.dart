import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/storage/shared_preferences_provider.dart';
import 'features/notifications/presentation/providers/notification_service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inter ships in assets/google_fonts/: never fetch fonts from Google at
  // runtime (works offline, and the app makes no font requests).
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  AppLogger.log('========================================');
  AppLogger.log('APP START');
  AppLogger.log('========================================');

  // SharedPreferences backs the Premium entitlement cache. If it cannot
  // be loaded the app still starts (the user is treated as Free).
  SharedPreferences? preferences;
  try {
    preferences = await SharedPreferences.getInstance();
  } catch (error) {
    AppLogger.log('SharedPreferences unavailable: $error');
  }

  // Create a single ProviderContainer for the entire application.
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
    ],
  );

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