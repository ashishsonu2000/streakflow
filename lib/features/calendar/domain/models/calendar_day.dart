import 'package:flutter/foundation.dart';

@immutable
class CalendarDay {
  const CalendarDay({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.totalHabits,
    required this.completedHabits,
    required this.progress,
    required this.completedHabitIds,
  });

  final DateTime date;

  final bool isCurrentMonth;

  final bool isToday;

  final bool isSelected;

  final int totalHabits;

  final int completedHabits;

  final double progress;

  final Set<String> completedHabitIds;

  bool get hasActivity => completedHabits > 0;

  bool get isPerfect => totalHabits > 0 && completedHabits == totalHabits;
}
