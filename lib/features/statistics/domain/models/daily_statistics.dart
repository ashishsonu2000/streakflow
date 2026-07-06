class DailyStatistics {
  final DateTime date;

  final int completedHabits;

  final int totalHabits;

  const DailyStatistics({
    required this.date,
    required this.completedHabits,
    required this.totalHabits,
  });

  double get progress {
    if (totalHabits == 0) {
      return 0;
    }

    return completedHabits / totalHabits;
  }

  int get completionPercentage {
    if (totalHabits == 0) {
      return 0;
    }

    return ((completedHabits / totalHabits) * 100).round();
  }
}
