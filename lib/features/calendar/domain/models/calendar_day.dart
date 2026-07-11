import 'package:flutter/foundation.dart';

@immutable
class CalendarDay {
  const CalendarDay({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.completedHabits,
    required this.totalHabits,
    required this.intensity,
  });

  final DateTime date;

  final bool isCurrentMonth;

  final bool isToday;

  final bool isSelected;

  final int completedHabits;

  final int totalHabits;

  /// 0..4
  final int intensity;

  bool get hasActivity => completedHabits > 0;
}
