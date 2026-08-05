import '../../../statistics/domain/models/weekly_trend.dart';

class WeeklyProgressViewModel {
  const WeeklyProgressViewModel({
    required this.completionRate,
    required this.completed,
    required this.target,
    required this.totalXP,
    required this.activeDays,
    required this.changePercentage,
    required this.trend,
  });

  final double completionRate;

  final int completed;

  final int target;

  final int totalXP;

  final int activeDays;

  final double changePercentage;

  final WeeklyTrend trend;
}
