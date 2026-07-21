import '../calculators/xp_level_calculator.dart';
import '../models/habit.dart';
import '../models/xp_level.dart';

class HabitAnalyticsService {
  const HabitAnalyticsService();

  static int totalXp(List<Habit> habits) {
    return habits.fold(
      0,
      (sum, habit) => sum + habit.xp,
    );
  }

  static int totalCompleted(List<Habit> habits) {
    return habits.fold(
      0,
      (sum, habit) => sum + habit.totalCompleted,
    );
  }

  static int currentStreak(List<Habit> habits) {
    return habits.fold(
      0,
      (sum, habit) => sum + habit.currentStreak,
    );
  }

  static int bestStreak(List<Habit> habits) {
    return habits.fold(
      0,
      (sum, habit) => sum + habit.bestStreak,
    );
  }

  static int activeHabits(List<Habit> habits) {
    return habits.where((e) => !e.archived).length;
  }

  static int archivedHabits(List<Habit> habits) {
    return habits.where((e) => e.archived).length;
  }

  static int completedToday(List<Habit> habits) {
    return habits.where((e) => e.completedToday).length;
  }

  static int pendingToday(List<Habit> habits) {
    return habits
        .where(
          (e) => !e.archived && !e.completedToday,
        )
        .length;
  }

  static XPLevel level(List<Habit> habits) {
    return XPLevelCalculator.calculate(
      totalXp(habits),
    );
  }

  static double weeklyCompletion(
    List<Habit> habits,
  ) {
    if (habits.isEmpty) return 0;

    return completedToday(habits) / habits.length * 100;
  }

  static double monthlyCompletion(
    List<Habit> habits,
  ) {
    // Temporary
    return weeklyCompletion(habits);
  }

  static double successRate(
    List<Habit> habits,
  ) {
    final completed = totalCompleted(habits);

    if (completed == 0) return 0;

    return completedToday(habits) / completed * 100;
  }
}
