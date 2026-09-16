import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/utils/date_utils.dart';
import '../../data/entities/habit_entity.dart';
import '../../data/entities/habit_log_entity.dart';
import '../../data/mapper/habit_mapper.dart';
import '../../domain/calculators/streak_calculator.dart';
import '../../domain/enums/completion_status.dart';

class HabitStatisticsRebuilder {
  const HabitStatisticsRebuilder();

  static const HabitMapper _mapper = HabitMapper();

  Future<void> rebuild(Isar db) async {
    AppLogger.log(
      '========================================',
    );
    AppLogger.log(
      'REBUILDING HABIT STATISTICS',
    );
    AppLogger.log(
      '========================================',
    );

    final habits =
    await db.habitEntitys.where().findAll();

    AppLogger.log(
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
          habit: _mapper.toDomain(habit),
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

        AppLogger.log(
          '----------------------------------------',
        );

        AppLogger.log(
          habit.title,
        );

        AppLogger.log(
          'Start Date      : $startDate',
        );

        AppLogger.log(
          'End Date        : ${endDate ?? 'Ongoing'}',
        );

        AppLogger.log(
          'Logs            : ${logs.length}',
        );

        AppLogger.log(
          'Current Streak  : ${habit.currentStreak}',
        );

        AppLogger.log(
          'Best Streak     : ${habit.bestStreak}',
        );

        AppLogger.log(
          'Completed       : ${habit.totalCompleted}',
        );

        AppLogger.log(
          'Completed Today : ${habit.completedToday}',
        );
      }
    });

    AppLogger.log(
      '========================================',
    );

    AppLogger.log(
      'REBUILD COMPLETED',
    );

    AppLogger.log(
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