import 'package:flutter/foundation.dart';

@immutable
class MonthlyProgress {
  const MonthlyProgress({
    required this.month,
    required this.year,
    required this.completedDays,
    required this.missedDays,
    required this.targetDays,
    required this.completionRate,
  });

  final int month;

  final int year;

  final int completedDays;

  final int missedDays;

  final int targetDays;

  /// 0.0 -> 1.0
  final double completionRate;

  String get monthLabel {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${months[month]} $year";
  }
}