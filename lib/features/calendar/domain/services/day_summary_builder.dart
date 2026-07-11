import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/models/habit.dart';

import '../models/day_summary.dart';

class DaySummaryBuilder {
  const DaySummaryBuilder();

  DaySummary build({
    required DateTime date,
    required List<Habit> habits,
    required List<HabitLogEntity> logs,
  }) {
    final completedIds = logs
        .where(
          (log) =>
              log.date.year == date.year &&
              log.date.month == date.month &&
              log.date.day == date.day,
        )
        .map(
          (e) => e.habitId,
        )
        .toSet();

    final completed = habits
        .where(
          (h) => completedIds.contains(h.id),
        )
        .toList();

    final missed = habits
        .where(
          (h) => !completedIds.contains(h.id),
        )
        .toList();

    final xp = logs
        .where(
          (log) =>
              log.date.year == date.year &&
              log.date.month == date.month &&
              log.date.day == date.day,
        )
        .fold(
          0,
          (sum, log) => sum + log.xpEarned,
        );

    return DaySummary(
      date: date,
      completed: completed,
      missed: missed,
      totalXp: xp,
      currentStreak: completed.fold(
        0,
        (sum, habit) => sum + habit.currentStreak,
      ),
    );
  }
}
