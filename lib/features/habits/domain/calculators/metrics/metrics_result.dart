import 'package:flutter/foundation.dart';

@immutable
class MetricsResult {
  const MetricsResult({
    required this.totalHabits,
    required this.completedToday,
    required this.pendingToday,
    required this.weeklyCompletion,
    required this.monthlyCompletion,
    required this.completionRate,
    required this.progress,
  });

  final int totalHabits;
  final int completedToday;
  final int pendingToday;

  /// Percentage (0-100)
  final double weeklyCompletion;

  /// Percentage (0-100)
  final double monthlyCompletion;

  /// Percentage (0-100)
  final double completionRate;

  /// Progress (0-1)
  final double progress;
}
