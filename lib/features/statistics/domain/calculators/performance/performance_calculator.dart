import '../../../../habits/domain/models/habit.dart';
import '../../../../habits/domain/models/habit_log.dart';

import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';

import '../../models/habit_performance.dart';

import '../common/streak_result.dart';
import '../overview/streak_calculator.dart';

class PerformanceCalculator
    implements Calculator<StatisticsContext, List<HabitPerformance>> {
  const PerformanceCalculator();

  @override
  List<HabitPerformance> calculate(
    StatisticsContext context,
  ) {
    final performances = <HabitPerformance>[];

    for (final habit in context.habits) {
      final logs = context.logsByHabit[habit.id] ?? const <HabitLog>[];

      final completed = logs.length;

      final xp = logs.fold<int>(
        0,
        (sum, log) => sum + log.xpEarned,
      );

      final completionRate = _calculateCompletionRate(
        habit,
        logs,
      );

      final streak = _calculateCurrentStreak(
        logs,
      );

      performances.add(
        HabitPerformance(
          habitId: habit.id,
          title: habit.title,
          completionRate: completionRate,
          currentStreak: streak.currentStreak,
          bestStreak: streak.longestStreak,
          totalCompleted: completed,
          totalXP: xp,
        ),
      );
    }

    performances.sort(
      (a, b) => b.completionRate.compareTo(
        a.completionRate,
      ),
    );

    return performances;
  }

  double _calculateCompletionRate(
    Habit habit,
    List<HabitLog> logs,
  ) {
    if (logs.isEmpty) {
      return 0;
    }

    final today = DateTime.now();

    final created = DateTime(
      habit.createdAt.year,
      habit.createdAt.month,
      habit.createdAt.day,
    );

    final days = today.difference(created).inDays + 1;

    if (days <= 0) {
      return 0;
    }

    return logs.length / days;
  }

  StreakResult _calculateCurrentStreak(
    List<HabitLog> logs,
  ) {
    return const StreakCalculator().calculate(
      logs,
    );
  }
}
