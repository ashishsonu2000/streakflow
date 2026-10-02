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
    this.lifetimeCompletions = 0,
    this.lifetimeXP = 0,
  });

  final double completionRate;

  final int currentStreak;

  final int bestStreak;

  final int totalHabits;

  /// TODAY's completions (see [lifetimeCompletions] for all time).
  final int totalCompletions;

  /// XP earned TODAY (see [lifetimeXP] for all time).
  final int totalXP;

  /// Minutes logged TODAY.
  final int totalDurationMinutes;

  final int perfectDays;

  /// All completions ever recorded (achievements).
  final int lifetimeCompletions;

  /// All XP ever earned (dashboard level, achievements).
  final int lifetimeXP;

  OverviewStatistics copyWith({
    double? completionRate,
    int? currentStreak,
    int? bestStreak,
    int? totalHabits,
    int? totalCompletions,
    int? totalXP,
    int? totalDurationMinutes,
    int? perfectDays,
    int? lifetimeCompletions,
    int? lifetimeXP,
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
      lifetimeCompletions: lifetimeCompletions ?? this.lifetimeCompletions,
      lifetimeXP: lifetimeXP ?? this.lifetimeXP,
    );
  }
}
