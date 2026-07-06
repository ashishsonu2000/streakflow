import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/models/habit.dart';
import '../models/dashboard_analytics.dart';

class WeeklyProgressCalculator {
  const WeeklyProgressCalculator._();

  static List<WeeklyAnalytics> calculate(
    List<Habit> habits,
    List<HabitLogEntity> logs,
  ) {
    final today = DateTime.now();

    final monday = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(
      Duration(days: today.weekday - 1),
    );

    final result = <WeeklyAnalytics>[];

    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));

      final completed = logs.where(
        (log) =>
            log.date.year == day.year &&
            log.date.month == day.month &&
            log.date.day == day.day,
      );

      result.add(
        WeeklyAnalytics(
          date: day,
          completed: completed.isNotEmpty,
          completedHabits: completed.length,
          totalHabits: habits.length,
        ),
      );
    }

    return result;
  }
}
