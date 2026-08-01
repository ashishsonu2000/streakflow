class DayCompletion {
  const DayCompletion({
    required this.date,
    required this.totalHabits,
    required this.completedHabits,
  });

  final DateTime date;

  final int totalHabits;

  final int completedHabits;
}
