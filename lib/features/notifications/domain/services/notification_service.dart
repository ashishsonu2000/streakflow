import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'habit_reminders';
  static const String _channelName = 'Habit Reminders';
  static const String _channelDescription =
      'Reminders for your habits';

  static const int _testNotificationId = 999999;

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

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
    );

    AppLogger.log(
      'Plugin initialized: true',
    );

    final android =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(
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

    final enabled =
        await android?.areNotificationsEnabled() ?? false;

    AppLogger.log(
      'Notifications enabled BEFORE permission request: $enabled',
    );

    if (!enabled) {
      final result =
      await android?.requestNotificationsPermission();

      AppLogger.log(
        'Notification permission result: $result',
      );
    }

    final enabledAfter =
        await android?.areNotificationsEnabled() ?? false;

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

    final android =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) {
      AppLogger.log(
        'Android notification implementation is NULL',
      );

      return false;
    }

    final result =
    await android.requestNotificationsPermission();

    AppLogger.log(
      'Permission request result: $result',
    );

    final enabled =
        await android.areNotificationsEnabled() ?? false;

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

  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitTitle,
    required int hour,
    required int minute,
    required DateTime startDate,
    DateTime? endDate,
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
      'Time       : '
          '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}',
    );

    AppLogger.log(
      'Start      : $startDate',
    );

    AppLogger.log(
      'End        : $endDate',
    );

    AppLogger.log(
      'Timezone   : ${tz.local.name}',
    );

    AppLogger.log(
      'TZ Now     : ${tz.TZDateTime.now(tz.local)}',
    );

    final android =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final notificationsEnabled =
        await android?.areNotificationsEnabled() ?? false;

    AppLogger.log(
      'Notifications enabled: $notificationsEnabled',
    );

    if (!notificationsEnabled) {
      AppLogger.log(
        'NOTIFICATION DISABLED -> NOT SCHEDULING',
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
    // STEP 2: Calculate dates
    // =======================================================

    final today = _dateOnly(
      DateTime.now(),
    );

    var firstDate = _dateOnly(
      startDate,
    );

    if (firstDate.isBefore(today)) {
      firstDate = today;
    }

    AppLogger.log(
      'STEP 2: Calculating dates...',
    );

    AppLogger.log(
      'Today      : $today',
    );

    AppLogger.log(
      'First date : $firstDate',
    );

    // =======================================================
    // STEP 3: Check end date
    // =======================================================

    AppLogger.log(
      'STEP 3: Checking habit duration...',
    );

    if (endDate != null) {
      final normalizedEndDate =
      _dateOnly(endDate);

      AppLogger.log(
        'End date   : $normalizedEndDate',
      );

      if (normalizedEndDate.isBefore(today)) {
        AppLogger.log(
          'Habit already ended -> NOT SCHEDULING',
        );

        return;
      }

      // -----------------------------------------------------
      // FINITE HABIT
      // -----------------------------------------------------

      AppLogger.log(
        'STEP 3: FINITE HABIT',
      );

      var date = firstDate;

      while (!date.isAfter(normalizedEndDate)) {
        await _scheduleSingleHabitReminder(
          habitId: habitId,
          habitTitle: habitTitle,
          date: date,
          hour: hour,
          minute: minute,
        );

        date = date.add(
          const Duration(days: 1),
        );
      }

      await _printPendingNotifications();

      return;
    }

    // =======================================================
    // STEP 4: Ongoing habit
    // =======================================================

    AppLogger.log(
      'STEP 4: ONGOING HABIT',
    );

    AppLogger.log(
      'STEP 4: Scheduling daily reminder...',
    );

    await _scheduleDailyRecurring(
      habitId: habitId,
      habitTitle: habitTitle,
      firstDate: firstDate,
      hour: hour,
      minute: minute,
    );

    AppLogger.log(
      'STEP 4: Ongoing reminder scheduled successfully.',
    );

    await _printPendingNotifications();
  }

  // =========================================================
  // Daily Recurring Reminder
  // =========================================================

  Future<void> _scheduleDailyRecurring({
    required String habitId,
    required String habitTitle,
    required DateTime firstDate,
    required int hour,
    required int minute,
  }) async {
    AppLogger.log(
      '---------- DAILY RECURRING ----------',
    );

    final scheduledDate = _nextValidTime(
      firstDate,
      hour,
      minute,
    );

    final now = tz.TZDateTime.now(
      tz.local,
    );

    AppLogger.log(
      '_nextValidTime() => $scheduledDate',
    );

    AppLogger.log(
      'Scheduled time : $scheduledDate',
    );

    AppLogger.log(
      'Current time   : $now',
    );

    // If today's time has already passed,
    // schedule tomorrow instead.
    if (!scheduledDate.isAfter(now)) {
      final tomorrow = firstDate.add(
        const Duration(days: 1),
      );

      final tomorrowDate = _nextValidTime(
        tomorrow,
        hour,
        minute,
      );

      AppLogger.log(
        'Today time already passed.',
      );

      AppLogger.log(
        'Scheduling tomorrow: $tomorrowDate',
      );

      await _scheduleRecurring(
        habitId: habitId,
        habitTitle: habitTitle,
        scheduledDate: tomorrowDate,
      );

      return;
    }

    AppLogger.log(
      'Scheduling today: $scheduledDate',
    );

    await _scheduleRecurring(
      habitId: habitId,
      habitTitle: habitTitle,
      scheduledDate: scheduledDate,
    );
  }

  // =========================================================
  // Actual Recurring Schedule
  // =========================================================

  Future<void> _scheduleRecurring({
    required String habitId,
    required String habitTitle,
    required tz.TZDateTime scheduledDate,
  }) async {
    final notificationId =
    _notificationId(habitId);

    AppLogger.log(
      'Notification ID: $notificationId',
    );

    final details =
    _habitNotificationDetails();

    AppLogger.log(
      'BEFORE zonedSchedule()',
    );

    await _notifications.zonedSchedule(
      notificationId,
      habitTitle,
      'Time to complete your habit.',
      scheduledDate,
      details,
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents:
      DateTimeComponents.time,
    );

    AppLogger.log(
      'AFTER zonedSchedule(): SUCCESS',
    );

    AppLogger.log(
      'Reminder will repeat daily at '
          '${scheduledDate.hour.toString().padLeft(2, '0')}:'
          '${scheduledDate.minute.toString().padLeft(2, '0')} '
          '${tz.local.name}',
    );
  }

  // =========================================================
  // Single Notification
  // =========================================================

  Future<void> _scheduleSingleHabitReminder({
    required String habitId,
    required String habitTitle,
    required DateTime date,
    required int hour,
    required int minute,
  }) async {
    final scheduledDate = _nextValidTime(
      date,
      hour,
      minute,
    );

    final now = tz.TZDateTime.now(
      tz.local,
    );

    AppLogger.log(
      '----------------------------------------',
    );

    AppLogger.log(
      'Single reminder',
    );

    AppLogger.log(
      'Date      : $date',
    );

    AppLogger.log(
      'Scheduled : $scheduledDate',
    );

    AppLogger.log(
      'Now       : $now',
    );

    if (!scheduledDate.isAfter(now)) {
      AppLogger.log(
        'Scheduled time already passed -> SKIP',
      );

      return;
    }

    final notificationId =
    _notificationIdForDate(
      habitId,
      date,
    );

    AppLogger.log(
      'Notification ID: $notificationId',
    );

    await _notifications.zonedSchedule(
      notificationId,
      habitTitle,
      'Time to complete your habit.',
      scheduledDate,
      _habitNotificationDetails(),
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
    );

    AppLogger.log(
      'Single reminder scheduled SUCCESSFULLY',
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
    );
  }

  // =========================================================
  // Next Valid Time
  // =========================================================

  tz.TZDateTime _nextValidTime(
      DateTime date,
      int hour,
      int minute,
      ) {
    return tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  // =========================================================
  // Cancel Habit Reminder
  // =========================================================

  Future<void> cancelHabitReminder(
      String habitId,
      ) async {
    final notificationId =
    _notificationId(habitId);

    AppLogger.log(
      'Cancelling recurring ID: $notificationId',
    );

    await _notifications.cancel(
      notificationId,
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

  // =========================================================
  // Date Only
  // =========================================================

  DateTime _dateOnly(
      DateTime date,
      ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // =========================================================
  // Notification ID
  // =========================================================

  int _notificationId(
      String habitId,
      ) {
    return habitId.hashCode.abs();
  }

  int _notificationIdForDate(
      String habitId,
      DateTime date,
      ) {
    final value =
        '$habitId-${date.year}-${date.month}-${date.day}';

    return value.hashCode.abs();
  }
}