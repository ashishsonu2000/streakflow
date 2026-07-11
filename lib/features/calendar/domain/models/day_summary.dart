import '../../../habits/domain/models/habit.dart';

class DaySummary {
  const DaySummary({
    required this.date,
    required this.completed,
    required this.missed,
    required this.totalXp,
    required this.currentStreak,
  });

  final DateTime date;

  final List<Habit> completed;

  final List<Habit> missed;

  final int totalXp;

  final int currentStreak;

  int get totalHabits => completed.length + missed.length;

  double get completionRate =>
      totalHabits == 0 ? 0 : completed.length / totalHabits;
}
