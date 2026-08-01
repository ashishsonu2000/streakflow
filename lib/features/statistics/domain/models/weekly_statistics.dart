class WeeklyStatistics {
  const WeeklyStatistics({
    required this.dailyCompletionRate,
    required this.totalCompleted,
    required this.totalXP,
    required this.totalDurationMinutes,
  });

  final List<double> dailyCompletionRate;

  final int totalCompleted;

  final int totalXP;

  final int totalDurationMinutes;
}
