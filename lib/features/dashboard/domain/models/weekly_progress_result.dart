import 'package:flutter/foundation.dart';

@immutable
class WeeklyProgressResult {
  const WeeklyProgressResult({
    required this.weeklyCompletion,
    required this.monthlyCompletion,
    required this.successRate,
  });

  final double weeklyCompletion;
  final double monthlyCompletion;
  final double successRate;
}
