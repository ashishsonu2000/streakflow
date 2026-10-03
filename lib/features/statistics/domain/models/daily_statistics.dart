class DailyStatistics {
  const DailyStatistics({
    required this.date,
    required this.completedHabits,
    required this.targetHabits,
    required this.completionRate,
    required this.totalXP,
    required this.totalDurationMinutes,
    required this.isPerfectDay,
    required this.isToday,
    required this.completedHabitIds,
  });

  final DateTime date;

  final int completedHabits;

  final int targetHabits;

  final double completionRate;

  final int totalXP;

  final int totalDurationMinutes;

  final bool isPerfectDay;

  final bool isToday;

  final Set<String> completedHabitIds;

  /// Backward-compatible alias.
  int get totalHabits => targetHabits;
}