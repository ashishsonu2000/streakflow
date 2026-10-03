class StreakResult {
  const StreakResult({
    required this.currentStreak,
    required this.longestStreak,
    required this.completedDays,
    required this.perfectDays,
  });

  /// Current consecutive streak
  final int currentStreak;

  /// Best streak achieved
  final int longestStreak;

  /// Total unique completed days
  final int completedDays;

  /// Number of perfect days
  ///
  /// Currently this is equal to completedDays.
  /// Later it can represent days where all scheduled habits
  /// were completed.
  final int perfectDays;

  StreakResult copyWith({
    int? currentStreak,
    int? longestStreak,
    int? completedDays,
    int? perfectDays,
  }) {
    return StreakResult(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completedDays: completedDays ?? this.completedDays,
      perfectDays: perfectDays ?? this.perfectDays,
    );
  }

  static const empty = StreakResult(
    currentStreak: 0,
    longestStreak: 0,
    completedDays: 0,
    perfectDays: 0,
  );
}
