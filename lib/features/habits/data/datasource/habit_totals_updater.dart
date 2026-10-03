import 'package:isar_community/isar.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/calculators/streak_calculator.dart';
import '../../domain/enums/completion_status.dart';
import '../../domain/models/habit.dart';
import '../entities/habit_entity.dart';
import '../entities/habit_log_entity.dart';
import 'habit_log_queries.dart';

/// Recalculates a habit's stored totals from its logs after a
/// completion is added or undone: streaks, completed count, XP,
/// today's completion and the latest completion time.
class HabitTotalsUpdater {
  const HabitTotalsUpdater();

  /// Updates and saves [entity]. [habit] is its domain model, used by
  /// the streak calculation. Must run inside a write transaction.
  Future<void> update(
      Isar db,
      HabitEntity entity, {
        required Habit habit,
      }) async {
    final logs = await db.habitLogEntitys
        .filter()
        .habitIdEqualTo(entity.uuid)
        .findAll();

    final completedLogs = logs
        .where(
          (item) =>
      item.status ==
          CompletionStatus.completed,
    )
        .toList();

    // -------------------------------------------------------
    // Streak
    // -------------------------------------------------------

    final streak = StreakCalculator.calculate(
      completedLogs,
      habit: habit,
    );

    entity.currentStreak =
        streak.currentStreak;

    entity.bestStreak =
        streak.longestStreak;

    entity.totalCompleted =
        completedLogs.length;

    // -------------------------------------------------------
    // XP
    // -------------------------------------------------------

    entity.xp =
        completedLogs.fold<int>(
          0,
              (total, item) =>
          total + item.xpEarned,
        );

    // -------------------------------------------------------
    // Today's completion cache
    // -------------------------------------------------------

    entity.completedToday =
    await db.habitLogEntitys.isCompletedOn(
      entity.uuid,
      AppDateUtils.today,
    );

    // -------------------------------------------------------
    // Latest completion
    // -------------------------------------------------------

    completedLogs.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    entity.lastCompletedDate =
    completedLogs.isEmpty
        ? null
        : completedLogs.first.completedAt;

    entity.updatedAt = DateTime.now();

    await db.habitEntitys.put(
      entity,
    );
  }
}
