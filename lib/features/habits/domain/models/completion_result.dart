class CompletionResult {
  final int completedDays;
  final int completionRate;
  final int weeklyCompleted;
  final int monthlyCompleted;

  const CompletionResult({
    required this.completedDays,
    required this.completionRate,
    required this.weeklyCompleted,
    required this.monthlyCompleted,
  });
}
