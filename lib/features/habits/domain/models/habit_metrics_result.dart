import '../../../statistics/domain/calculators/common/streak_result.dart';

class HabitMetricsResult {
  final StreakResult streak;

  final int totalCompleted;

  final int completedThisWeek;

  final int completedThisMonth;

  final double weeklyCompletionRate;

  final double monthlyCompletionRate;

  final int totalXp;

  const HabitMetricsResult({
    required this.streak,
    required this.totalCompleted,
    required this.completedThisWeek,
    required this.completedThisMonth,
    required this.weeklyCompletionRate,
    required this.monthlyCompletionRate,
    required this.totalXp,
  });
}
