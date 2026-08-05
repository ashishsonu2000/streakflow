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

    final start = today.subtract(
      Duration(days: today.weekday - 1),
    );

    final end = start.add(
      const Duration(days: 7),
    );

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
