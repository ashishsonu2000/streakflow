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
}
