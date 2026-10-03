import 'package:flutter/foundation.dart';

@immutable
class CalendarDay {
  const CalendarDay({
    required this.label,
    required this.weekday,
  });

  final String label;
  final int weekday;

  static const days = [
    CalendarDay(label: 'Mon', weekday: DateTime.monday),
    CalendarDay(label: 'Tue', weekday: DateTime.tuesday),
    CalendarDay(label: 'Wed', weekday: DateTime.wednesday),
    CalendarDay(label: 'Thu', weekday: DateTime.thursday),
    CalendarDay(label: 'Fri', weekday: DateTime.friday),
    CalendarDay(label: 'Sat', weekday: DateTime.saturday),
    CalendarDay(label: 'Sun', weekday: DateTime.sunday),
  ];
}
