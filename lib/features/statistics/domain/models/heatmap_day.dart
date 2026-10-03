import 'package:flutter/foundation.dart';

@immutable
class HeatmapDay {
  const HeatmapDay({
    required this.date,
    required this.completions,
  });

  final DateTime date;

  final int completions;
}