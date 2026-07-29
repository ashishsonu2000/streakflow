import '../../data/entities/habit_log_entity.dart';
import '../../../statistics/domain/models/daily_statistics.dart';
import '../models/habit.dart';

class WeeklyProgressCalculator {
  const WeeklyProgressCalculator._();

  static List<DailyStatistics> calculate(
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

    final result = <DailyStatistics>[];

    for (var i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));

      final completedHabits = logs
          .where(
            (log) =>
                log.date.year == day.year &&
                log.date.month == day.month &&
                log.date.day == day.day,
          )
          .length;

      result.add(
        DailyStatistics(
          date: day,
          completedHabits: completedHabits,
          totalHabits: habits.length,
        ),
      );
    }

    return result;
  }
}
