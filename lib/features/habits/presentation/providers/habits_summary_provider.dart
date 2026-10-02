import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../provider/habit_providers.dart';


/// Summary metrics for the Habits screen.
///
/// Today's numbers come from [habitsProvider] (habits due today);
/// best streak and total XP from [allActiveHabitsProvider], so they
/// don't change with the weekday when weekly/monthly habits exist.
///
/// Search, category filters and sorting do not affect the numbers.
class HabitsSummary {
  const HabitsSummary({
    required this.totalHabits,
    required this.completedToday,
    required this.pendingToday,
    required this.completionPercentage,
    required this.bestStreak,
    required this.totalXP,
  });

  final int totalHabits;
  final int completedToday;
  final int pendingToday;
  final int completionPercentage;
  final int bestStreak;
  final int totalXP;

  bool get allCompleted =>
      totalHabits > 0 && completedToday == totalHabits;
}

final habitsSummaryProvider =
Provider<AsyncValue<HabitsSummary>>((ref) {
  final habitsAsync = ref.watch(habitsProvider);
  final allHabits = ref.watch(allActiveHabitsProvider).value;

  return habitsAsync.whenData(
        (habits) {
      if (habits.isEmpty) {
        return const HabitsSummary(
          totalHabits: 0,
          completedToday: 0,
          pendingToday: 0,
          completionPercentage: 0,
          bestStreak: 0,
          totalXP: 0,
        );
      }

      final completedToday = habits
          .where(
            (habit) => habit.completedToday,
      )
          .length;

      final totalHabits = habits.length;

      final pendingToday =
          totalHabits - completedToday;

      final completionPercentage =
      ((completedToday / totalHabits) * 100).round();

      // Every active habit, not only today's.
      final everyHabit = allHabits ?? habits;

      final bestStreak = everyHabit.fold<int>(
        0,
            (best, habit) {
          return habit.bestStreak > best
              ? habit.bestStreak
              : best;
        },
      );

      final totalXP = everyHabit.fold<int>(
        0,
            (total, habit) {
          return total + habit.xp;
        },
      );

      return HabitsSummary(
        totalHabits: totalHabits,
        completedToday: completedToday,
        pendingToday: pendingToday,
        completionPercentage: completionPercentage,
        bestStreak: bestStreak,
        totalXP: totalXP,
      );
    },
  );
});