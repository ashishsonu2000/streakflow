class MonthlyStatistics {
  const MonthlyStatistics({
    required this.monthlyCompletionRate,
    required this.totalCompleted,
    required this.totalXP,
    required this.totalDurationMinutes,
  });

  final double monthlyCompletionRate;

  final int totalCompleted;

  final int totalXP;

  final int totalDurationMinutes;
}
