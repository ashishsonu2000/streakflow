class HabitStatistics {
  final String habitId;

  final String title;

  final int currentStreak;

  final int bestStreak;

  final int totalCompleted;

  final int xp;

  final double completionRate;

  const HabitStatistics({
    required this.habitId,
    required this.title,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompleted,
    required this.xp,
    required this.completionRate,
  });
}
