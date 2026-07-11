import 'package:flutter/foundation.dart';

@immutable
class CalendarDayState {
  const CalendarDayState({
    required this.date,
    required this.completedHabits,
    required this.totalHabits,
    required this.intensity,
    required this.isToday,
    required this.isSelected,
    required this.isCurrentMonth,
  });

  final DateTime date;

  final int completedHabits;

  final int totalHabits;

  /// 0..4
  final int intensity;

  final bool isToday;

  final bool isSelected;

  final bool isCurrentMonth;

  bool get hasActivity => completedHabits > 0;

  double get completionRate =>
      totalHabits == 0 ? 0 : completedHabits / totalHabits;
}
