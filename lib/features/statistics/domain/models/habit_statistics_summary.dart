class HabitStatisticsSummary {
  const HabitStatisticsSummary({
    required this.habitId,
    required this.title,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompleted,
    required this.totalXP,
    required this.completionRate,
  });

  final String habitId;
  final String title;

  final int currentStreak;
  final int bestStreak;
  final int totalCompleted;
  final int totalXP;

  final double completionRate;
}
