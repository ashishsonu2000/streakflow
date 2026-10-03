class HabitPerformance {
  const HabitPerformance({
    required this.habitId,
    required this.title,
    required this.completionRate,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompleted,
    required this.totalXP,
    this.rank = 0,
  });

  final String habitId;

  final String title;

  final double completionRate;

  final int currentStreak;

  final int bestStreak;

  final int totalCompleted;

  final int totalXP;

  final int rank;
}