class StatisticsDateUtils {
  const StatisticsDateUtils._();

  static DateTime normalize(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  static bool isSameDay(
    DateTime a,
    DateTime b,
  ) {
    return normalize(a) == normalize(b);
  }

  static bool isToday(
    DateTime date,
  ) {
    return isSameDay(
      date,
      DateTime.now(),
    );
  }

  static bool isThisWeek(
    DateTime date,
  ) {
    final today = normalize(
      DateTime.now(),
    );

    // Calendar arithmetic (daylight-saving days are not 24 h).
    final start = DateTime(
      today.year,
      today.month,
      today.day - (today.weekday - 1),
    );

    final end = DateTime(start.year, start.month, start.day + 7);

    final value = normalize(date);

    return !value.isBefore(start) && value.isBefore(end);
  }

  static bool isThisMonth(
    DateTime date,
  ) {
    final now = DateTime.now();

    return date.year == now.year && date.month == now.month;
  }
}
