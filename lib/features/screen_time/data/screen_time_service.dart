import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/app_logger.dart';

/// A screen-time limit for the Android background check
/// (ScreenTimeWorker.kt): notify when today's screen time reaches
/// [limitMinutes], on the [days] the habit is scheduled.
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

/// Screen time from Android's UsageStatsManager, through
/// MainActivity.kt. Every call is a no-op on other platforms: iPhone
/// screen-time habits are checked in by hand until Phase 2
/// (docs/DIGITAL_DETOX.md).
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

  /// Whether this platform can measure screen time (Android only).
  bool get isSupported =>
      _supported ??
      (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);

  /// Whether the user has turned on "Usage access" for StreakFlow.
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

  /// Opens the system "Usage access" settings screen.
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

  /// Hands the limits to the background check. An empty list (or
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
