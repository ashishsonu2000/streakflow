class HabitAnalyticsResult {
  final int completionRate;
  final int completedThisWeek;
  final int completedThisMonth;
  final int totalCompleted;
  final int longestGap;
  final int currentMonthTarget;
  final int currentMonthCompleted;

  const HabitAnalyticsResult({
    required this.completionRate,
    required this.completedThisWeek,
    required this.completedThisMonth,
    required this.totalCompleted,
    required this.longestGap,
    required this.currentMonthTarget,
    required this.currentMonthCompleted,
  });
}
