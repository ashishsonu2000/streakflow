import '../../../data/entities/habit_log_entity.dart';
import '../../models/habit.dart';

import '../weekly_progress_calculator.dart';
import 'metrics_result.dart';

class MetricsCalculator {
  const MetricsCalculator._();

  static MetricsResult calculate(
    List<Habit> habits,
    List<HabitLogEntity> logs,
  ) {
    final today = DateTime.now();

    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    //----------------------------------
    // Today's completed habits
    //----------------------------------

    final completedTodayIds = logs
        .where((log) =>
            log.completedAt != null && isSameDay(log.completedAt!, today))
        .map((log) => log.habitId)
        .toSet();

    final totalHabits = habits.length;

    final completedToday = completedTodayIds.length;

    final pendingToday = (totalHabits - completedToday).clamp(
      0,
      totalHabits,
    );

    //----------------------------------
    // Weekly
    //----------------------------------

    final weekStart = today.subtract(
      Duration(days: today.weekday - 1),
    );

    final weeklyLogs = logs.where(
      (log) => log.completedAt != null && !log.completedAt!.isBefore(weekStart),
    );

    final weeklyCompletion =
        totalHabits == 0 ? 0.0 : (weeklyLogs.length / (totalHabits * 7)) * 100;

    //----------------------------------
    // Monthly
    //----------------------------------

    final monthStart = DateTime(
      today.year,
      today.month,
      1,
    );

    final monthlyLogs = logs.where(
      (log) =>
          log.completedAt != null && !log.completedAt!.isBefore(monthStart),
    );

    final daysInMonth = DateTime(
      today.year,
      today.month + 1,
      0,
    ).day;

    final monthlyCompletion = totalHabits == 0
        ? 0.0
        : (monthlyLogs.length / (totalHabits * daysInMonth)) * 100;

    //----------------------------------
    // Overall completion
    //----------------------------------

    final completionRate =
        totalHabits == 0 ? 0.0 : (completedToday / totalHabits) * 100;

    //----------------------------------
    // Today's progress (0-1)
    //----------------------------------

    final progress = totalHabits == 0 ? 0.0 : completedToday / totalHabits;

    // Weekly
    final weeklyProgress = WeeklyProgressCalculator.calculate(
      habits,
      logs,
    );

    return MetricsResult(
      totalHabits: totalHabits,
      completedToday: completedToday,
      pendingToday: pendingToday,
      weeklyCompletion: weeklyCompletion.clamp(0, 100),
      monthlyCompletion: monthlyCompletion.clamp(0, 100),
      completionRate: completionRate.clamp(0, 100),
      progress: progress.clamp(0.0, 1.0),
    );
  }
}
