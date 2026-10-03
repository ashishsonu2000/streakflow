import '../../data/entities/habit_log_entity.dart';

import 'analytics/heatmap_day.dart';
import 'habit.dart';

import 'monthly_progress.dart';
import 'statistic_tile.dart';
import 'weekly_progress.dart';

class HabitDetail {
  const HabitDetail({
    required this.habit,
    required this.completionRate,
    required this.weeklyProgress,
    required this.monthlyProgress,
    required this.statistics,
    required this.heatmap,
    required this.logs,
  });

  final Habit habit;

  /// 0..1
  final double completionRate;

  final WeeklyProgress weeklyProgress;

  final MonthlyProgress monthlyProgress;

  final List<StatisticTileModel> statistics;

  final List<HeatmapDay> heatmap;

  final List<HabitLogEntity> logs;
}
