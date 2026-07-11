import 'package:flutter/foundation.dart';

@immutable
class HeatmapDay {
  const HeatmapDay({
    required this.date,
    required this.completed,
    required this.intensity,
    required this.xp,
  });

  final DateTime date;

  final bool completed;

  /// 0..4
  final int intensity;

  final int xp;
}
