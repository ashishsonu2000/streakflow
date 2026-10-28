import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
// latest_all (not latest): includes legacy zone names such as
// "Asia/Calcutta", which many Android devices still report. With the
// smaller database those lookups failed and reminders fell back to UTC
// (5h30m late in India).
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'reminder_schedule.dart';

class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'habit_reminders';
  static const String _channelName = 'Habit Reminders';
  static const String _channelDescription =
      'Reminders for your habits';

  static const int _testNotificationId = 999999;

  /// The in-app "Habit Reminders" switch (Settings → Notifications).
  /// Missing means on: reminders are already opt-in per habit.
  static const String remindersEnabledKey = 'notifications_enabled';

  /// Whether the user has left habit reminders switched on in the app.
  static Future<bool> remindersSwitchedOn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(remindersEnabledKey) ?? true;
  }

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  IOSFlutterLocalNotificationsPlugin? get _ios =>
      _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

  /// Whether the OS (Android or iOS) currently allows this app to post
  /// notifications.
  Future<bool> isPermissionGranted() async {
    final android = _android;
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }

    final ios = _ios;
    if (ios != null) {
      final options = await ios.checkPermissions();
      return options?.isEnabled ?? false;
    }

    return false;
  }

  /// Shows the OS permission prompt (Android 13+ / iOS). Once the user
  /// has answered, iOS never prompts again and just returns the answer.
  Future<void> _requestPlatformPermission() async {
    final android = _android;
    if (android != null) {
      final result = await android.requestNotificationsPermission();
      AppLogger.log('Android permission request result: $result');
      return;
    }

    final ios = _ios;
    if (ios != null) {
      final result = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      AppLogger.log('iOS permission request result: $result');
    }
  }

  // =========================================================
  // Initialize
  // =========================================================

  Future<void> initialize() async {
    AppLogger.log('========================================');
    AppLogger.log('NOTIFICATION SERVICE INITIALIZE');
    AppLogger.log('========================================');

    // Initialize timezone database.
    tz.initializeTimeZones();

    // Use the device's actual timezone so reminders fire at the
    // time the user picked in their own local time, not IST.
    try {
      final deviceTimezone =
          await FlutterTimezone.getLocalTimezone();

      tz.setLocalLocation(
        tz.getLocation(deviceTimezone.identifier),
      );
    } catch (error) {
      AppLogger.log(
        'Failed to resolve device timezone, '
            'falling back to UTC: $error',
      );

      tz.setLocalLocation(tz.UTC);
    }

    AppLogger.log(
      'Timezone: ${tz.local.name}',
    );

    AppLogger.log(
      'Current TZ time: ${tz.TZDateTime.now(tz.local)}',
    );

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // Permission is requested below (and from Settings → Notifications),
    // not by the plugin during initialize().
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notifications.initialize(
      settings,
    );

    AppLogger.log(
      'Plugin initialized: true',
    );

    await _android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );

    AppLogger.log(
      'Notification channel created: $_channelId',
    );

    final enabled = await isPermissionGranted();

    AppLogger.log(
      'Notifications enabled BEFORE permission request: $enabled',
    );

    if (!enabled) {
      await _requestPlatformPermission();
    }

    final enabledAfter = await isPermissionGranted();

    AppLogger.log(
      'Notifications enabled AFTER permission request: '
          '$enabledAfter',
    );

    if (enabledAfter) {
      AppLogger.log(
        'NOTIFICATION PERMISSION: GRANTED',
      );
    } else {
      AppLogger.log(
        'NOTIFICATION PERMISSION: DENIED',
      );
    }

    AppLogger.log(
      '========================================',
    );
    AppLogger.log(
      'NOTIFICATION INITIALIZATION SUCCESS',
    );
    AppLogger.log(
      '========================================',
    );
  }

  // =========================================================
  // Permission
  // =========================================================

  Future<bool> requestPermission() async {
    AppLogger.log(
      '========================================',
    );
    AppLogger.log(
      'REQUEST NOTIFICATION PERMISSION',
    );
    AppLogger.log(
      '========================================',
    );

    if (_android == null && _ios == null) {
      AppLogger.log(
        'No Android/iOS notification implementation',
      );

      return false;
    }

    await _requestPlatformPermission();

    final enabled = await isPermissionGranted();

    AppLogger.log(
      'Notifications enabled: $enabled',
    );

    return enabled;
  }

  // =========================================================
  // Test Notification
  // =========================================================

  Future<void> showNow() async {
    AppLogger.log(
      '========================================',
    );
    AppLogger.log(
      'SHOW TEST NOTIFICATION',
    );
    AppLogger.log(
      '========================================',
    );

    final details = _habitNotificationDetails();

    await _notifications.show(
      _testNotificationId,
      'StreakFlow',
      'This is a test notification.',
      details,
    );

    AppLogger.log(
      'TEST NOTIFICATION SENT',
    );
  }

  // =========================================================
  // Schedule Habit Reminder
  // =========================================================

  /// Replaces a habit's reminders with [entries] (see ReminderPlanner).
  ///
  /// Existing reminders for the habit are cancelled first, so an empty
  /// [entries] list just removes them (e.g. the habit has ended).
  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitTitle,
    required List<ReminderEntry> entries,
  }) async {
    AppLogger.log(
      '========================================',
    );
    AppLogger.log(
      'SCHEDULE HABIT REMINDER',
    );
    AppLogger.log(
      '========================================',
    );

    AppLogger.log(
      'Habit ID   : $habitId',
    );

    AppLogger.log(
      'Habit      : $habitTitle',
    );

    AppLogger.log(
      'Reminders  : ${entries.length}',
    );

    AppLogger.log(
      'Timezone   : ${tz.local.name}',
    );

    AppLogger.log(
      'TZ Now     : ${tz.TZDateTime.now(tz.local)}',
    );

    final notificationsEnabled = await isPermissionGranted();

    AppLogger.log(
      'Notifications enabled: $notificationsEnabled',
    );

    if (!notificationsEnabled) {
      AppLogger.log(
        'NOTIFICATION DISABLED -> NOT SCHEDULING',
      );

      return;
    }

    // The user switched habit reminders off in the app.
    if (!await remindersSwitchedOn()) {
      AppLogger.log(
        'REMINDERS SWITCHED OFF IN APP -> NOT SCHEDULING',
      );

      return;
    }

    // =======================================================
    // STEP 1: Cancel existing notifications for this habit
    // =======================================================

    AppLogger.log(
      'STEP 1: Cancelling existing reminder...',
    );

    await cancelHabitReminder(habitId);

    AppLogger.log(
      'STEP 1: Existing reminder cancelled.',
    );

    // =======================================================
    // STEP 2: Schedule the planned reminders
    // =======================================================

    if (entries.isEmpty) {
      AppLogger.log(
        'STEP 2: Nothing to schedule (no upcoming occurrence).',
      );

      return;
    }

    AppLogger.log(
      'STEP 2: Scheduling ${entries.length} reminder(s)...',
    );

    for (final entry in entries) {
      await _scheduleEntry(
        habitId: habitId,
        habitTitle: habitTitle,
        entry: entry,
      );
    }

    AppLogger.log(
      'STEP 2: Reminders scheduled successfully.',
    );

    await _printPendingNotifications();
  }

  // =========================================================
  // Single Planned Reminder
  // =========================================================

  Future<void> _scheduleEntry({
    required String habitId,
    required String habitTitle,
    required ReminderEntry entry,
  }) async {
    final scheduledDate = tz.TZDateTime(
      tz.local,
      entry.at.year,
      entry.at.month,
      entry.at.day,
      entry.at.hour,
      entry.at.minute,
    );

    AppLogger.log(
      'Reminder   : id ${entry.id}, slot ${entry.slot}, '
          '$scheduledDate, repeat ${entry.repeat.name}',
    );

    await _notifications.zonedSchedule(
      entry.id,
      habitTitle,
      'Time to complete your habit.',
      scheduledDate,
      _habitNotificationDetails(),
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: switch (entry.repeat) {
        ReminderRepeat.none => null,
        ReminderRepeat.daily => DateTimeComponents.time,
        ReminderRepeat.weekly => DateTimeComponents.dayOfWeekAndTime,
        ReminderRepeat.monthly => DateTimeComponents.dayOfMonthAndTime,
      },
      payload: ReminderIds.payload(habitId),
    );
  }

  // =========================================================
  // Notification Details
  // =========================================================

  NotificationDetails _habitNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentList: true,
        presentSound: true,
      ),
    );
  }

  // =========================================================
  // Cancel Habit Reminder
  // =========================================================

  /// Cancels every reminder of a habit: the repeating reminder of each
  /// slot, plus any one-off (end-dated) reminders tagged with the
  /// habit's payload.
  Future<void> cancelHabitReminder(
      String habitId,
      ) async {
    for (var slot = 0; slot < ReminderIds.maxSlots; slot++) {
      await _notifications.cancel(
        ReminderIds.recurring(habitId, slot),
      );
    }

    final payload = ReminderIds.payload(habitId);
    final pending =
        await _notifications.pendingNotificationRequests();

    var cancelledOneOff = 0;
    for (final request in pending) {
      if (request.payload == payload) {
        await _notifications.cancel(request.id);
        cancelledOneOff++;
      }
    }

    AppLogger.log(
      'Cancelled reminders for $habitId '
      '(${ReminderIds.maxSlots} slots, $cancelledOneOff one-off)',
    );

    AppLogger.log(
      'Habit reminder cancellation completed.',
    );
  }

  // =========================================================
  // Cancel All
  // =========================================================

  Future<void> cancelAll() async {
    AppLogger.log(
      'Cancelling ALL notifications',
    );

    await _notifications.cancelAll();

    AppLogger.log(
      'All notifications cancelled.',
    );
  }

  // =========================================================
  // Debug: Pending Notifications
  // =========================================================

  Future<void> _printPendingNotifications() async {
    final pending =
    await _notifications.pendingNotificationRequests();

    AppLogger.log(
      '========================================',
    );

    AppLogger.log(
      'PENDING NOTIFICATIONS: ${pending.length}',
    );

    for (final notification in pending) {
      AppLogger.log(
        'Pending ID    : ${notification.id}',
      );

      AppLogger.log(
        'Pending title : ${notification.title}',
      );

      AppLogger.log(
        'Pending body  : ${notification.body}',
      );
    }

    AppLogger.log(
      '========================================',
    );
  }
}