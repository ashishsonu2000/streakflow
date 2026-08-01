class CompletionTrend {
  const CompletionTrend({
    required this.date,
    required this.completionRate,
    required this.xp,
    required this.durationMinutes,
  });

  final DateTime date;

  final double completionRate;

  final int xp;

  final int durationMinutes;
}
