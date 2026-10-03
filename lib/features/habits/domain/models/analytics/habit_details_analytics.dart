import 'package:flutter/foundation.dart';


import '../../../../../core/models/completion_trend.dart';

import 'heatmap_day.dart';



@immutable
class HabitDetailAnalytics {
  const HabitDetailAnalytics({
    required this.completionRate,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompleted,
    required this.totalXp,
    required this.weeklyData,
    required this.monthlyData,
    required this.heatmap,
  });

  /// Value between 0.0 and 1.0

  final double completionRate;

  final int currentStreak;

  final int bestStreak;

  final int totalCompleted;

  final int totalXp;

  final List<CompletionTrend> weeklyData;

  final List<CompletionTrend> monthlyData;

  final List<HeatmapDay> heatmap;
}