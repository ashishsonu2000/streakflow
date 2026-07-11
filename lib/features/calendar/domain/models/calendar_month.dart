import 'calendar_day.dart';

class CalendarMonth {
  const CalendarMonth({
    required this.year,
    required this.month,
    required this.days,
  });

  final int year;

  final int month;

  final List<CalendarDay> days;

  String get title {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return "${months[month]} $year";
  }
}
