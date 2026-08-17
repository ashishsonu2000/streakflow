import '../../data/entities/habit_log_entity.dart';
import 'analytics/heatmap_day.dart';
import 'habit.dart';
import 'habit_statistics.dart';

import 'monthly_progress.dart';
import 'weekly_progress.dart';

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.habit,
    required this.statistics,
    required this.weeklyProgress,
    required this.monthlyProgress,
    required this.heatmap,
    required this.logs,
  });

  final Habit habit;

  final HabitStatistics statistics;

  final WeeklyProgress weeklyProgress;

  final MonthlyProgress monthlyProgress;

  final List<HeatmapDay> heatmap;

  final List<HabitLogEntity> logs;
}
