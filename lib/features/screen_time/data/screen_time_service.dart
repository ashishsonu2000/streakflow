import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/app_logger.dart';

/// A screen-time limit for the background check (Android:
/// ScreenTimeWorker.kt; iPhone: the DeviceActivityMonitor extension):
/// notify when today's screen time reaches [limitMinutes], on the
/// [days] the habit is scheduled.
class ScreenTimeLimitAlert {
  const ScreenTimeLimitAlert({
    required this.habitId,
    required this.title,
    required this.limitMinutes,
    required this.days,
  });

  final String habitId;
  final String title;
  final int limitMinutes;

  /// Scheduled days as yyyy-MM-dd (local time).
  final List<String> days;

  Map<String, Object> toMap() => {
        'id': habitId,
        'title': title,
        'limitMinutes': limitMinutes,
        'days': days,
      };
}

/// Screen time through the platform channel:
///
/// * Android (MainActivity.kt): usage minutes from UsageStatsManager,
///   after the user turns on "Usage access".
/// * iPhone, iOS 16+ (ScreenTimeBridge.swift): Apple's Screen Time API.
///   The user grants permission and picks the apps that count; the app
///   never sees minutes, only whether a day's limit was reached.
///
/// See docs/DIGITAL_DETOX.md.
class ScreenTimeService {
  const ScreenTimeService({
    MethodChannel channel = _defaultChannel,
    bool? supported,
  })  : _channel = channel,
        _supported = supported;

  static const _defaultChannel =
      MethodChannel('com.codesapience.streakflow/screen_time');

  final MethodChannel _channel;
  final bool? _supported;

  /// Whether this platform has a screen-time channel (Android, iOS).
  /// On iOS also check [isAvailable] (iOS 16+).
  bool get isSupported =>
      _supported ??
      (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS));

  bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Whether screen time can be used on this device: always on
  /// Android, iOS 16 or later on iPhone.
  Future<bool> isAvailable() async {
    if (!isSupported) return false;
    if (!isIOS) return true;

    try {
      return await _channel.invokeMethod<bool>('isSupported') ?? false;
    } on PlatformException catch (error) {
      AppLogger.log('[ScreenTime] isSupported failed: $error');
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Android: "Usage access" is on. iPhone: Screen Time permission is
  /// granted and at least one app or category is chosen.
  Future<bool> hasUsageAccess() async {
    if (!isSupported) return false;

    try {
      return await _channel.invokeMethod<bool>('hasUsageAccess') ?? false;
    } on PlatformException catch (error) {
      AppLogger.log('[ScreenTime] hasUsageAccess failed: $error');
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Android: opens the system "Usage access" settings screen.
  /// iPhone: asks for Screen Time permission, then shows Apple's app
  /// picker; completes once the picker is closed.
  Future<void> openUsageAccessSettings() async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod<void>('openUsageAccessSettings');
    } on PlatformException catch (error) {
      AppLogger.log('[ScreenTime] openUsageAccessSettings failed: $error');
    } on MissingPluginException {
      // Not available (tests).
    }
  }

  /// Minutes of screen time between [start] and [end], or null when
  /// unknown: no usage access, or Android has no usage data for the
  /// period (device off all day, or older than Android keeps).
  Future<int?> minutesBetween(DateTime start, DateTime end) async {
    if (!isSupported) return null;

    try {
      return await _channel.invokeMethod<int>('screenTimeMinutes', {
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      });
    } on PlatformException catch (error) {
      AppLogger.log('[ScreenTime] screenTimeMinutes failed: $error');
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  /// Screen time on the local calendar [day] (up to now for today).
  Future<int?> minutesOn(DateTime day) => minutesBetween(
        DateTime(day.year, day.month, day.day),
        DateTime(day.year, day.month, day.day + 1),
      );

  /// iPhone: whether the limit was kept on a past [day]: true (stayed
  /// under), false (reached) or null (not monitored that day).
  Future<bool?> dayResult(String habitId, DateTime day) async {
    if (!isIOS) return null;

    try {
      return await _channel.invokeMethod<bool>('dayResult', {
        'id': habitId,
        'day': ymd(day),
      });
    } on PlatformException catch (error) {
      AppLogger.log('[ScreenTime] dayResult failed: $error');
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  /// State of permissions, limits and the native side's recent events,
  /// for the hidden diagnostics panel. Values are text or lists of text.
  Future<Map<String, Object?>> diagnostics() async {
    if (!isSupported) return const {'Screen time': 'not supported here'};

    try {
      final result =
          await _channel.invokeMapMethod<String, Object?>('diagnostics');
      return result ?? const {};
    } on PlatformException catch (error) {
      return {'Error': error.toString()};
    } on MissingPluginException {
      return const {'Error': 'Screen time channel missing'};
    }
  }

  /// iPhone: starts a test alert that fires after 1 minute in the chosen
  /// apps. Returns what happened, to show to the user.
  Future<String> startTestAlert() async {
    if (!isIOS) return 'The test alert is for iPhone.';

    try {
      return await _channel.invokeMethod<String>('startTestAlert') ??
          'No answer from iOS.';
    } on PlatformException catch (error) {
      return 'Failed: $error';
    } on MissingPluginException {
      return 'Screen time channel missing.';
    }
  }

  /// yyyy-MM-dd, the day format shared with the native side.
  static String ymd(DateTime day) => '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';

  /// Hands the limits to the background check (Android: WorkManager;
  /// iPhone: DeviceActivity monitors). An empty list (or
  /// [enabled] false) stops it.
  Future<void> syncLimits({
    required bool enabled,
    required List<ScreenTimeLimitAlert> limits,
  }) async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod<void>('syncLimits', {
        'enabled': enabled,
        'limits': [for (final limit in limits) limit.toMap()],
      });
    } on PlatformException catch (error) {
      AppLogger.log('[ScreenTime] syncLimits failed: $error');
    } on MissingPluginException {
      // Not available (tests).
    }
  }
}
