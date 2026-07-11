import 'package:flutter/foundation.dart';

@immutable
class WeekDayProgress {
  const WeekDayProgress({
    required this.day,
    required this.date,
    required this.completed,
    required this.isToday,
  });

  final String day;

  final DateTime date;

  final bool completed;

  final bool isToday;
}

@immutable
class WeeklyProgress {
  const WeeklyProgress({
    required this.days,
    required this.completedCount,
  });

  final List<WeekDayProgress> days;

  final int completedCount;

  double get percentage => days.isEmpty ? 0 : completedCount / days.length;
}
