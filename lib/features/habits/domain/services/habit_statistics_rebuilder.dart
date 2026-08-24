import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/utils/date_utils.dart';
import '../../data/entities/habit_entity.dart';
import '../../data/entities/habit_log_entity.dart';
import '../../domain/calculators/streak_calculator.dart';
import '../../domain/enums/completion_status.dart';

class HabitStatisticsRebuilder {
  const HabitStatisticsRebuilder();

  Future<void> rebuild(Isar db) async {
    debugPrint(
      '========================================',
    );
    debugPrint(
      'REBUILDING HABIT STATISTICS',
    );
    debugPrint(
      '========================================',
    );

    final habits =
    await db.habitEntitys.where().findAll();

    debugPrint(
      'Habits found: ${habits.length}',
    );

    final today =
        AppDateUtils.today;

    final tomorrow =
        AppDateUtils.tomorrow;

    await db.writeTxn(() async {
      for (final habit in habits) {
        final logs = await db.habitLogEntitys
            .filter()
            .habitIdEqualTo(
          habit.uuid,
        )
            .sortByDate()
            .findAll();

        // =====================================================
        // Habit Schedule
        // =====================================================

        // Existing habits created before the schedule fields
        // were introduced use createdAt as their start date.
        final startDate =
        _dateOnly(
          habit.startDate ??
              habit.createdAt,
        );

        final endDate =
        habit.endDate == null
            ? null
            : _dateOnly(
          habit.endDate!,
        );

        // =====================================================
        // Streak
        // =====================================================

        final streak =
        StreakCalculator.calculate(
          logs,
          startDate: startDate,
          endDate: endDate,
        );

        // =====================================================
        // Completed Today
        // =====================================================

        final completedToday =
        logs.any(
              (e) =>
          e.status ==
              CompletionStatus.completed &&
              !e.date.isBefore(today) &&
              e.date.isBefore(tomorrow),
        );

        // =====================================================
        // Completed Logs
        // =====================================================

        final completedLogs =
        logs
            .where(
              (e) =>
          e.status ==
              CompletionStatus.completed,
        )
            .toList();

        // =====================================================
        // Update Statistics
        // =====================================================

        habit.currentStreak =
            streak.currentStreak;

        habit.bestStreak =
            streak.longestStreak;

        habit.totalCompleted =
            streak.completedDays;

        habit.completedToday =
            completedToday;

        habit.lastCompletedDate =
        completedLogs.isEmpty
            ? null
            : completedLogs.last.completedAt;

        habit.updatedAt =
            DateTime.now();

        await db.habitEntitys.put(
          habit,
        );

        // =====================================================
        // Debug
        // =====================================================

        debugPrint(
          '----------------------------------------',
        );

        debugPrint(
          habit.title,
        );

        debugPrint(
          'Start Date      : $startDate',
        );

        debugPrint(
          'End Date        : ${endDate ?? 'Ongoing'}',
        );

        debugPrint(
          'Logs            : ${logs.length}',
        );

        debugPrint(
          'Current Streak  : ${habit.currentStreak}',
        );

        debugPrint(
          'Best Streak     : ${habit.bestStreak}',
        );

        debugPrint(
          'Completed       : ${habit.totalCompleted}',
        );

        debugPrint(
          'Completed Today : ${habit.completedToday}',
        );
      }
    });

    debugPrint(
      '========================================',
    );

    debugPrint(
      'REBUILD COMPLETED',
    );

    debugPrint(
      '========================================',
    );
  }

  DateTime _dateOnly(
      DateTime date,
      ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}