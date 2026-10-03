import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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