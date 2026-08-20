import '../../data/entities/habit_log_entity.dart';
import '../../../statistics/domain/models/daily_statistics.dart';
import '../models/habit.dart';

class WeeklyProgressCalculator {
  const WeeklyProgressCalculator._();

  static List<DailyStatistics> calculate(
      List<Habit> habits,
      List<HabitLogEntity> logs,
      ) {
    final now = DateTime.now();

    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(
      Duration(
        days: now.weekday - 1,
      ),
    );

    final result = <DailyStatistics>[];

    for (var i = 0; i < 7; i++) {
      final day = startOfWeek.add(
        Duration(days: i),
      );

      final dayLogs = logs.where(
            (log) {
          return log.date.year == day.year &&
              log.date.month == day.month &&
              log.date.day == day.day;
        },
      ).toList();

      final completedHabitIds = dayLogs
          .map(
            (log) => log.habitId,
      )
          .toSet();

      final completedHabits =
          completedHabitIds.length;

      final targetHabits = habits.length;

      final completionRate =
      targetHabits == 0
          ? 0.0
          : completedHabits /
          targetHabits;

      final totalXP = dayLogs.fold<int>(
        0,
            (total, log) =>
        total + log.xpEarned,
      );

      final totalDurationMinutes =
      dayLogs.fold<int>(
        0,
            (total, log) =>
        total + log.durationMinutes,
      );

      final isToday =
          day.year == now.year &&
              day.month == now.month &&
              day.day == now.day;

      final isPerfectDay =
          targetHabits > 0 &&
              completedHabits >= targetHabits;

      result.add(
        DailyStatistics(
          date: day,
          completedHabits:
          completedHabits,
          targetHabits:
          targetHabits,
          completionRate:
          completionRate,
          totalXP:
          totalXP,
          totalDurationMinutes:
          totalDurationMinutes,
          isPerfectDay:
          isPerfectDay,
          isToday:
          isToday,
          completedHabitIds:
          completedHabitIds,
        ),
      );
    }

    return result;
  }
}