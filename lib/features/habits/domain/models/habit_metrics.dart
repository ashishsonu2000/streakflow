class HabitMetrics {
  final int completedThisWeek;
  final int completedThisMonth;
  final double weeklyCompletionRate;
  final double monthlyCompletionRate;

  const HabitMetrics({
    required this.completedThisWeek,
    required this.completedThisMonth,
    required this.weeklyCompletionRate,
    required this.monthlyCompletionRate,
  });
}
