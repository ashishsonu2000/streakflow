class ActivityTimeFormatter {
  /// Relative label for an activity time.
  ///
  /// Within today: minutes/hours ago. Earlier: by calendar day, so
  /// 23:00 yesterday is "Yesterday" (not "9 hr ago") and anything from
  /// two calendar days back is "2 days ago" (not "Yesterday").
  static String format(DateTime date, {DateTime? now}) {
    final current = now ?? DateTime.now();

    final days = _calendarDaysBetween(date, current);

    if (days <= 0) {
      final diff = current.difference(date);

      if (diff.inMinutes < 1) {
        return "Just now";
      }

      if (diff.inHours < 1) {
        return "${diff.inMinutes} min ago";
      }

      return "${diff.inHours} hr ago";
    }

    if (days == 1) {
      return "Yesterday";
    }

    return "$days days ago";
  }

  // UTC dates so daylight-saving changes can't skew the day count.
  static int _calendarDaysBetween(DateTime from, DateTime to) =>
      DateTime.utc(to.year, to.month, to.day)
          .difference(DateTime.utc(from.year, from.month, from.day))
          .inDays;
}
