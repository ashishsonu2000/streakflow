class MonthlyStatistics {
  const MonthlyStatistics({
    required this.monthlyCompletionRate,
    required this.totalCompleted,
    required this.totalXP,
    required this.totalDurationMinutes,
    required this.perfectDays,
  });

  final double monthlyCompletionRate;

  final int totalCompleted;

  final int totalXP;

  final int totalDurationMinutes;

  final int perfectDays;

  MonthlyStatistics copyWith({
    double? monthlyCompletionRate,
    int? totalCompleted,
    int? totalXP,
    int? totalDurationMinutes,
    int? perfectDays,
  }) {
    return MonthlyStatistics(
      monthlyCompletionRate:
          monthlyCompletionRate ?? this.monthlyCompletionRate,
      totalCompleted: totalCompleted ?? this.totalCompleted,
      totalXP: totalXP ?? this.totalXP,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      perfectDays: perfectDays ?? this.perfectDays,
    );
  }
}
