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

  /// Number of days completed this week.
  final int completedCount;

  /// Progress between 0.0 and 1.0.
  double get overallProgress =>
      days.isEmpty ? 0.0 : completedCount / days.length;

  /// Percentage between 0 and 100.
  double get percentage => overallProgress * 100;

  /// Whether every day this week has been completed.
  bool get isPerfectWeek => days.isNotEmpty && completedCount == days.length;
}
