import 'weekday_statistics.dart';
import 'weekly_trend.dart';

class WeeklyStatistics {
  const WeeklyStatistics({
    required this.days,
    required this.completionRate,
    required this.previousWeekCompletionRate,
    required this.weeklyChangePercentage,
    required this.trend,
    required this.totalCompleted,
    required this.totalTarget,
    required this.totalXP,
    required this.totalDurationMinutes,
    required this.activeDays,
    required this.bestDay,
    required this.worstDay,
  });

  final List<WeekdayStatistics> days;

  final double completionRate;

  final double previousWeekCompletionRate;

  final double weeklyChangePercentage;

  final WeeklyTrend trend;

  final int totalCompleted;

  final int totalTarget;

  final int totalXP;

  final int totalDurationMinutes;

  final int activeDays;

  final WeekdayStatistics bestDay;

  final WeekdayStatistics worstDay;

  bool get hasActivity => totalCompleted > 0;

  WeeklyStatistics copyWith({
    List<WeekdayStatistics>? days,
    double? completionRate,
    double? previousWeekCompletionRate,
    double? weeklyChangePercentage,
    WeeklyTrend? trend,
    int? totalCompleted,
    int? totalTarget,
    int? totalXP,
    int? totalDurationMinutes,
    int? activeDays,
    WeekdayStatistics? bestDay,
    WeekdayStatistics? worstDay,
  }) {
    return WeeklyStatistics(
      days: days ?? this.days,
      completionRate: completionRate ?? this.completionRate,
      previousWeekCompletionRate:
          previousWeekCompletionRate ?? this.previousWeekCompletionRate,
      weeklyChangePercentage:
          weeklyChangePercentage ?? this.weeklyChangePercentage,
      trend: trend ?? this.trend,
      totalCompleted: totalCompleted ?? this.totalCompleted,
      totalTarget: totalTarget ?? this.totalTarget,
      totalXP: totalXP ?? this.totalXP,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      activeDays: activeDays ?? this.activeDays,
      bestDay: bestDay ?? this.bestDay,
      worstDay: worstDay ?? this.worstDay,
    );
  }
}
