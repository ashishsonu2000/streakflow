class OverviewStatistics {
  const OverviewStatistics({
    required this.completionRate,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalHabits,
    required this.totalCompletions,
    required this.totalXP,
    required this.totalDurationMinutes,
    required this.perfectDays,
  });

  final double completionRate;

  final int currentStreak;

  final int bestStreak;

  final int totalHabits;

  final int totalCompletions;

  final int totalXP;

  final int totalDurationMinutes;

  final int perfectDays;

  OverviewStatistics copyWith({
    double? completionRate,
    int? currentStreak,
    int? bestStreak,
    int? totalHabits,
    int? totalCompletions,
    int? totalXP,
    int? totalDurationMinutes,
    int? perfectDays,
  }) {
    return OverviewStatistics(
      completionRate: completionRate ?? this.completionRate,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalHabits: totalHabits ?? this.totalHabits,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      totalXP: totalXP ?? this.totalXP,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      perfectDays: perfectDays ?? this.perfectDays,
    );
  }
}
