class MonthlyStatistics {
  const MonthlyStatistics({
    required this.monthlyCompletionRate,
    required this.totalCompleted,
    required this.totalXP,
    required this.totalDurationMinutes,
    required this.perfectDays,

    // New monthly metrics
    this.totalScheduled = 0,
    this.totalMissed = 0,
    this.previousMonthCompletionRate = 0.0,
    this.monthlyChangePercentage = 0.0,
  });

  // =========================================================
  // Existing metrics
  // =========================================================

  final double monthlyCompletionRate;

  final int totalCompleted;

  final int totalXP;

  final int totalDurationMinutes;

  final int perfectDays;

  // =========================================================
  // New monthly metrics
  // =========================================================

  /// Number of habit occurrences that were scheduled
  /// during the month.
  final int totalScheduled;

  /// Number of scheduled occurrences that were not completed.
  final int totalMissed;

  /// Completion rate of the previous month.
  final double previousMonthCompletionRate;

  /// Difference between this month and previous month,
  /// expressed as percentage points.
  ///
  /// Example:
  ///
  /// Current month = 82%
  /// Previous month = 74%
  ///
  /// monthlyChangePercentage = 8
  final double monthlyChangePercentage;

  // =========================================================
  // Convenience getters
  // =========================================================

  double get completionPercentage =>
      monthlyCompletionRate * 100;

  double get previousMonthPercentage =>
      previousMonthCompletionRate * 100;

  bool get isImproving =>
      monthlyChangePercentage > 0;

  bool get isDeclining =>
      monthlyChangePercentage < 0;

  bool get isStable =>
      monthlyChangePercentage == 0;

  // =========================================================
  // Copy With
  // =========================================================

  MonthlyStatistics copyWith({
    double? monthlyCompletionRate,
    int? totalCompleted,
    int? totalXP,
    int? totalDurationMinutes,
    int? perfectDays,
    int? totalScheduled,
    int? totalMissed,
    double? previousMonthCompletionRate,
    double? monthlyChangePercentage,
  }) {
    return MonthlyStatistics(
      monthlyCompletionRate:
      monthlyCompletionRate ??
          this.monthlyCompletionRate,

      totalCompleted:
      totalCompleted ??
          this.totalCompleted,

      totalXP:
      totalXP ??
          this.totalXP,

      totalDurationMinutes:
      totalDurationMinutes ??
          this.totalDurationMinutes,

      perfectDays:
      perfectDays ??
          this.perfectDays,

      totalScheduled:
      totalScheduled ??
          this.totalScheduled,

      totalMissed:
      totalMissed ??
          this.totalMissed,

      previousMonthCompletionRate:
      previousMonthCompletionRate ??
          this.previousMonthCompletionRate,

      monthlyChangePercentage:
      monthlyChangePercentage ??
          this.monthlyChangePercentage,
    );
  }

  @override
  String toString() {
    return '''
MonthlyStatistics(
  monthlyCompletionRate: $monthlyCompletionRate,
  totalScheduled: $totalScheduled,
  totalCompleted: $totalCompleted,
  totalMissed: $totalMissed,
  totalXP: $totalXP,
  totalDurationMinutes: $totalDurationMinutes,
  perfectDays: $perfectDays,
  previousMonthCompletionRate: $previousMonthCompletionRate,
  monthlyChangePercentage: $monthlyChangePercentage,
)
''';
  }
}