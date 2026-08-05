import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_log.dart';

import 'statistics_context.dart';

class StatisticsContextFactory {
  const StatisticsContextFactory();

  StatisticsContext create({
    required List<Habit> habits,
    required List<HabitLog> logs,
  }) {
    final context = StatisticsContext(
      habits: habits,
      logs: logs,
    );

    //--------------------------------------------
    // Completed Logs
    //--------------------------------------------

    context.completedLogs = logs
        .where(
          (log) => log.completedAt != null,
        )
        .toList();

    //--------------------------------------------
    // Habit Lookup
    //--------------------------------------------

    context.habitLookup = {
      for (final habit in habits) habit.id: habit,
    };

    //--------------------------------------------
    // Logs By Date
    //--------------------------------------------

    context.logsByDate = {};

    //--------------------------------------------
    // Logs By Habit
    //--------------------------------------------

    context.logsByHabit = {};

    for (final log in context.completedLogs) {
      final date = DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      );

      context.logsByDate.putIfAbsent(
        date,
        () => [],
      );

      context.logsByDate[date]!.add(log);

      context.logsByHabit.putIfAbsent(
        log.habitId,
        () => [],
      );

      context.logsByHabit[log.habitId]!.add(log);
    }

    return context;
  }
}
