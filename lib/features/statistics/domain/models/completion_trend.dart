class CompletionTrend {
  const CompletionTrend({
    required this.date,
    required this.completed,
    required this.total,
    required this.completionRate,
    required this.xp,
    required this.durationMinutes,
  });

  final DateTime date;
  final int completed;
  final int total;
  final double completionRate;
  final int xp;
  final int durationMinutes;

  double get percentage => completionRate * 100;

  bool get hasActivity => completed > 0;

  bool get isPerfectDay => total > 0 && completed >= total;
}
