class AppDateUtils {
  const AppDateUtils._();

  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime get tomorrow => today.add(const Duration(days: 1));

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isToday(DateTime date) {
    return dateOnly(date) == today;
  }

  static bool isYesterday(DateTime date) {
    return dateOnly(date) == today.subtract(const Duration(days: 1));
  }

  static DateTime startOfWeek([DateTime? date]) {
    final d = dateOnly(date ?? DateTime.now());
    return d.subtract(Duration(days: d.weekday - DateTime.monday));
  }

  static DateTime endOfWeek([DateTime? date]) {
    return startOfWeek(date).add(const Duration(days: 6));
  }

  static DateTime startOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month, 1);
  }

  static DateTime endOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month + 1, 0);
  }
}
