import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Returns:
  /// M T W T F S S
  static String weekdayShort(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return "M";
      case DateTime.tuesday:
        return "T";
      case DateTime.wednesday:
        return "W";
      case DateTime.thursday:
        return "T";
      case DateTime.friday:
        return "F";
      case DateTime.saturday:
        return "S";
      case DateTime.sunday:
        return "S";
      default:
        return "";
    }
  }

  /// Monday
  static String weekdayLong(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Mon
  static String weekdayMedium(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  /// 08 Jul
  static String dayMonth(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  /// 08 Jul 2026
  static String fullDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// 10:45 AM
  static String time(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// 08 Jul 2026 10:45 AM
  static String dateTime(DateTime date) {
    return DateFormat('dd MMM yyyy hh:mm a').format(date);
  }

  static String greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    }

    if (hour < 17) {
      return "Good Afternoon";
    }

    return "Good Evening";
  }

  static String timeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }

    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    }

    if (difference.inDays < 7) {
      return "${difference.inDays} day${difference.inDays == 1 ? "" : "s"} ago";
    }

    if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return "$weeks week${weeks == 1 ? "" : "s"} ago";
    }

    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return "$months month${months == 1 ? "" : "s"} ago";
    }

    final years = difference.inDays ~/ 365;
    return "$years year${years == 1 ? "" : "s"} ago";
  }
}
