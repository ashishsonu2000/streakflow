import 'package:flutter/foundation.dart';

@immutable
class HeatmapDay {
  const HeatmapDay({
    required this.date,
    required this.count,
  });

  final DateTime date;

  final int count;

  bool get isCompleted {
    return count > 0;
  }
}