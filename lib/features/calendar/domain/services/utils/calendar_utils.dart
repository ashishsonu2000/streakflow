class CalendarUtils {
  CalendarUtils._();

  static List<DateTime> visibleDates(
    DateTime month,
  ) {
    final firstDay = DateTime(
      month.year,
      month.month,
      1,
    );

    // Monday = 1 ... Sunday = 7
    final weekday = firstDay.weekday;

    final start = firstDay.subtract(
      Duration(days: weekday - 1),
    );

    return List.generate(
      42,
      (index) => start.add(
        Duration(days: index),
      ),
    );
  }
}
