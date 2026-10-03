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

  /// 🔥 Core values
  final double completionRate;
  final int completed;
  final int target;
  final int totalXP;
  final int activeDays;
  final double changePercentage;
  final WeeklyTrend trend;

  /// ✅ REQUIRED FOR UI
  double get progress => completionRate;

  /// ✅ FIX FOR YOUR ERROR
  int get xp => totalXP;

  /// ✅ UI helpers
  String get completionText => "$completed/$target";

  bool get isPositiveTrend => changePercentage >= 0;

  String get trendText =>
      "${changePercentage.abs().toStringAsFixed(1)}%";

  bool get isPerfectWeek => completed == target && target > 0;
}