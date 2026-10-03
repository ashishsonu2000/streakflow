import '../../../habits/domain/models/habit.dart';

class DashboardSummary {
  final List<Habit> habits;

  final int totalHabits;

  final int completedToday;

  final int currentStreak;

  final int bestStreak;

  final int totalXp;

  final double todayCompletion;

  const DashboardSummary({
    required this.habits,
    required this.totalHabits,
    required this.completedToday,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalXp,
    required this.todayCompletion,
  });
}
