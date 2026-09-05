import '../../../../habits/domain/models/habit.dart';
import '../../../../habits/domain/models/habit_log.dart';

import '../../../../habits/domain/services/habit_schedule_service.dart';
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
        habit,
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
    final today = DateTime.now();

    final start = DateTime(
      habit.startDate.year,
      habit.startDate.month,
      habit.startDate.day,
    );

    if (start.isAfter(today)) {
      return 0;
    }

    final end = habit.endDate == null
        ? DateTime(
      today.year,
      today.month,
      today.day,
    )
        : DateTime(
      habit.endDate!.year,
      habit.endDate!.month,
      habit.endDate!.day,
    );

    final completedDates = logs
        .map(
          (log) => DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      ),
    )
        .toSet();

    var scheduled = 0;
    var completed = 0;

    for (
    var day = start;
    !day.isAfter(end) && !day.isAfter(today);
    day = day.add(const Duration(days: 1))
    ) {
      if (!const HabitScheduleService()
          .isScheduledForDate(habit, day)) {
        continue;
      }

      scheduled++;

      if (completedDates.contains(day)) {
        completed++;
      }
    }

    if (scheduled == 0) {
      return 0;
    }

    return (completed / scheduled).clamp(0.0, 1.0);
  }

  StreakResult _calculateCurrentStreak(
      Habit habit,
      List<HabitLog> logs,
      ) {
    return const StreakCalculator().calculate(
      logs,
      habit: habit,
    );
  }
}
