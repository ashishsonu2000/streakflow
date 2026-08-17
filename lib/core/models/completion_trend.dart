import 'package:flutter/foundation.dart';

@immutable
class CompletionTrend {
  const CompletionTrend({
    required this.date,
    required this.completionRate,
  });

  final DateTime date;

  /// Value between 0.0 and 1.0.

  final double completionRate;
}