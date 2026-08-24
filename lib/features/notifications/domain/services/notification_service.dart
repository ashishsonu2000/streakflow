import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    debugPrint('========================================');
    debugPrint('NOTIFICATION SERVICE INITIALIZE');
    debugPrint('========================================');

    // Initialize timezone database.
    tz.initializeTimeZones();

    // IMPORTANT:
    // Set the timezone explicitly for India.
    tz.setLocalLocation(
      tz.getLocation('Asia/Kolkata'),
    );

    debugPrint(
      'Timezone: ${tz.local.name}',
    );

    debugPrint(
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

    debugPrint(
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

    debugPrint(
      'Notification channel created: $_channelId',
    );

    final enabled =
        await android?.areNotificationsEnabled() ?? false;

    debugPrint(
      'Notifications enabled BEFORE permission request: $enabled',
    );

    if (!enabled) {
      final result =
      await android?.requestNotificationsPermission();

      debugPrint(
        'Notification permission result: $result',
      );
    }

    final enabledAfter =
        await android?.areNotificationsEnabled() ?? false;

    debugPrint(
      'Notifications enabled AFTER permission request: '
          '$enabledAfter',
    );

    if (enabledAfter) {
      debugPrint(
        'NOTIFICATION PERMISSION: GRANTED',
      );
    } else {
      debugPrint(
        'NOTIFICATION PERMISSION: DENIED',
      );
    }

    debugPrint(
      '========================================',
    );
    debugPrint(
      'NOTIFICATION INITIALIZATION SUCCESS',
    );
    debugPrint(
      '========================================',
    );
  }

  // =========================================================
  // Permission
  // =========================================================

  Future<bool> requestPermission() async {
    debugPrint(
      '========================================',
    );
    debugPrint(
      'REQUEST NOTIFICATION PERMISSION',
    );
    debugPrint(
      '========================================',
    );

    final android =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) {
      debugPrint(
        'Android notification implementation is NULL',
      );

      return false;
    }

    final result =
    await android.requestNotificationsPermission();

    debugPrint(
      'Permission request result: $result',
    );

    final enabled =
        await android.areNotificationsEnabled() ?? false;

    debugPrint(
      'Notifications enabled: $enabled',
    );

    return enabled;
  }

  // =========================================================
  // Test Notification
  // =========================================================

  Future<void> showNow() async {
    debugPrint(
      '========================================',
    );
    debugPrint(
      'SHOW TEST NOTIFICATION',
    );
    debugPrint(
      '========================================',
    );

    final details = _habitNotificationDetails();

    await _notifications.show(
      _testNotificationId,
      'StreakFlow',
      'This is a test notification.',
      details,
    );

    debugPrint(
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
    debugPrint(
      '========================================',
    );
    debugPrint(
      'SCHEDULE HABIT REMINDER',
    );
    debugPrint(
      '========================================',
    );

    debugPrint(
      'Habit ID   : $habitId',
    );

    debugPrint(
      'Habit      : $habitTitle',
    );

    debugPrint(
      'Time       : '
          '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}',
    );

    debugPrint(
      'Start      : $startDate',
    );

    debugPrint(
      'End        : $endDate',
    );

    debugPrint(
      'Timezone   : ${tz.local.name}',
    );

    debugPrint(
      'TZ Now     : ${tz.TZDateTime.now(tz.local)}',
    );

    final android =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final notificationsEnabled =
        await android?.areNotificationsEnabled() ?? false;

    debugPrint(
      'Notifications enabled: $notificationsEnabled',
    );

    if (!notificationsEnabled) {
      debugPrint(
        'NOTIFICATION DISABLED -> NOT SCHEDULING',
      );

      return;
    }

    // =======================================================
    // STEP 1: Cancel existing notifications for this habit
    // =======================================================

    debugPrint(
      'STEP 1: Cancelling existing reminder...',
    );

    await cancelHabitReminder(habitId);

    debugPrint(
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

    debugPrint(
      'STEP 2: Calculating dates...',
    );

    debugPrint(
      'Today      : $today',
    );

    debugPrint(
      'First date : $firstDate',
    );

    // =======================================================
    // STEP 3: Check end date
    // =======================================================

    debugPrint(
      'STEP 3: Checking habit duration...',
    );

    if (endDate != null) {
      final normalizedEndDate =
      _dateOnly(endDate);

      debugPrint(
        'End date   : $normalizedEndDate',
      );

      if (normalizedEndDate.isBefore(today)) {
        debugPrint(
          'Habit already ended -> NOT SCHEDULING',
        );

        return;
      }

      // -----------------------------------------------------
      // FINITE HABIT
      // -----------------------------------------------------

      debugPrint(
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

    debugPrint(
      'STEP 4: ONGOING HABIT',
    );

    debugPrint(
      'STEP 4: Scheduling daily reminder...',
    );

    await _scheduleDailyRecurring(
      habitId: habitId,
      habitTitle: habitTitle,
      firstDate: firstDate,
      hour: hour,
      minute: minute,
    );

    debugPrint(
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
    debugPrint(
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

    debugPrint(
      '_nextValidTime() => $scheduledDate',
    );

    debugPrint(
      'Scheduled time : $scheduledDate',
    );

    debugPrint(
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

      debugPrint(
        'Today time already passed.',
      );

      debugPrint(
        'Scheduling tomorrow: $tomorrowDate',
      );

      await _scheduleRecurring(
        habitId: habitId,
        habitTitle: habitTitle,
        scheduledDate: tomorrowDate,
      );

      return;
    }

    debugPrint(
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

    debugPrint(
      'Notification ID: $notificationId',
    );

    final details =
    _habitNotificationDetails();

    debugPrint(
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

    debugPrint(
      'AFTER zonedSchedule(): SUCCESS',
    );

    debugPrint(
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

    debugPrint(
      '----------------------------------------',
    );

    debugPrint(
      'Single reminder',
    );

    debugPrint(
      'Date      : $date',
    );

    debugPrint(
      'Scheduled : $scheduledDate',
    );

    debugPrint(
      'Now       : $now',
    );

    if (!scheduledDate.isAfter(now)) {
      debugPrint(
        'Scheduled time already passed -> SKIP',
      );

      return;
    }

    final notificationId =
    _notificationIdForDate(
      habitId,
      date,
    );

    debugPrint(
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

    debugPrint(
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

    debugPrint(
      'Cancelling recurring ID: $notificationId',
    );

    await _notifications.cancel(
      notificationId,
    );

    debugPrint(
      'Habit reminder cancellation completed.',
    );
  }

  // =========================================================
  // Cancel All
  // =========================================================

  Future<void> cancelAll() async {
    debugPrint(
      'Cancelling ALL notifications',
    );

    await _notifications.cancelAll();

    debugPrint(
      'All notifications cancelled.',
    );
  }

  // =========================================================
  // Debug: Pending Notifications
  // =========================================================

  Future<void> _printPendingNotifications() async {
    final pending =
    await _notifications.pendingNotificationRequests();

    debugPrint(
      '========================================',
    );

    debugPrint(
      'PENDING NOTIFICATIONS: ${pending.length}',
    );

    for (final notification in pending) {
      debugPrint(
        'Pending ID    : ${notification.id}',
      );

      debugPrint(
        'Pending title : ${notification.title}',
      );

      debugPrint(
        'Pending body  : ${notification.body}',
      );
    }

    debugPrint(
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