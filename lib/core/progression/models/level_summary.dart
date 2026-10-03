class LevelSummary {
  const LevelSummary({
    required this.level,
    required this.totalXp,
    required this.previousLevelXp,
    required this.currentLevelXp,
    required this.nextLevelXp,
    required this.remainingXp,
    required this.progress,
  });

  final int level;

  /// Total accumulated XP
  final int totalXp;

  /// XP required to reach this level
  final int previousLevelXp;

  /// XP earned within the current level
  final int currentLevelXp;

  /// XP required to reach the next level
  final int nextLevelXp;

  final int remainingXp;

  /// 0.0 → 1.0
  final double progress;
}
