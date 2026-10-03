class HabitDayStatistics {
  const HabitDayStatistics({
    required this.date,
    required this.completed,
    required this.isWithinHabitRange,
  });

  final DateTime date;
  final bool completed;
  final bool isWithinHabitRange;

}