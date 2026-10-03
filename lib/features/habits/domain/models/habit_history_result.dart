class HabitHistoryResult {
  final int completedDays;
  final int missedDays;
  final int completionRate;
  final int completedThisWeek;
  final int completedThisMonth;
  final int longestGap;

  HabitHistoryResult(
      {required this.completedDays,
      required this.missedDays,
      required this.completionRate,
      required this.completedThisWeek,
      required this.completedThisMonth,
      required this.longestGap});
}
