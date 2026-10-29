/// Choices and formatting for "Digital detox" screen-time limits.
abstract final class ScreenTimeLimits {
  static const defaultMinutes = 120;

  /// Limits offered on the habit form: 30 minutes to 8 hours.
  static const choices = <int>[
    30, 45, 60, 90, 120, 150, 180, 240, 300, 360, 480, //
  ];

  /// The early-warning point: 80% of the limit.
  static int warningMinutes(int limitMinutes) => (limitMinutes * 4) ~/ 5;

  /// "45m", "2h", "1h 30m".
  static String format(int minutes) {
    final hours = minutes ~/ 60;
    final rest = minutes % 60;

    if (hours == 0) return '${rest}m';
    if (rest == 0) return '${hours}h';
    return '${hours}h ${rest}m';
  }
}
