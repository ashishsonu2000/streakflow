import '../../calculators/xp_level_calculator.dart';
import '../habit.dart';
import 'habit_analytics.dart';

class HabitAnalyticsBuilder {
  const HabitAnalyticsBuilder._();

  static HabitAnalytics build(
    List<Habit> habits,
  ) {
    var active = 0;
    var archived = 0;

    var completedToday = 0;

    var currentStreak = 0;
    var bestStreak = 0;

    var totalCompleted = 0;
    var totalXp = 0;

    for (final habit in habits) {
      if (habit.archived) {
        archived++;
      } else {
        active++;
      }

      if (habit.completedToday) {
        completedToday++;
      }

      currentStreak += habit.currentStreak;
      bestStreak += habit.bestStreak;
      totalCompleted += habit.totalCompleted;
      totalXp += habit.xp;
    }

    return HabitAnalytics(
      totalHabits: habits.length,
      activeHabits: active,
      archivedHabits: archived,
      completedToday: completedToday,
      pendingToday: active - completedToday,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      totalCompleted: totalCompleted,
      totalXp: totalXp,
      level: XPLevelCalculator.calculate(totalXp),
    );
  }
}
