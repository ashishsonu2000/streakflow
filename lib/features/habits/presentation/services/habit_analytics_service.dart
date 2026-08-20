
import '../../data/entities/habit_log_entity.dart';
import '../../domain/enums/completion_status.dart';

import '../../domain/models/analytics/heatmap_day.dart';
import '../../domain/models/habit.dart';
import '../../domain/models/habit_statistics.dart';

import '../../domain/models/monthly_progress.dart';
import '../../domain/models/weekly_progress.dart';

class HabitAnalyticsService {
  const HabitAnalyticsService();

  //--------------------------------------------------------
  // Statistics
  //--------------------------------------------------------

  HabitStatistics buildStatistics(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final tracking = trackingDays(habit);

    final completed = logs.length;

    final missed =
    tracking > completed
        ? tracking - completed
        : 0;

    return HabitStatistics(
      currentStreak: habit.currentStreak,
      bestStreak: habit.bestStreak,
      totalCompleted: completed,
      totalMissed: missed,
      totalTrackedDays: tracking,
      activeDays: activeDays(logs),
      totalXP: habit.xp,
      completionRate:
      completionRate(
        habit,
        logs,
      ),
      successRate:
      successRate(
        habit,
        logs,
      ),
      averagePerWeek:
      averagePerWeek(
        habit,
        logs,
      ),
      longestGap:
      longestGap(logs),
    );
  }

  //--------------------------------------------------------
  // Completion %
  //--------------------------------------------------------

  double completionRate(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final tracking = trackingDays(habit);

    if (tracking == 0) {
      return 0;
    }

    return logs.length / tracking;
  }

  //--------------------------------------------------------
  // Success %
  //--------------------------------------------------------

  double successRate(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    return completionRate(
      habit,
      logs,
    ) *
        100;
  }

  //--------------------------------------------------------
  // Average / Week
  //--------------------------------------------------------

  double averagePerWeek(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final tracking = trackingDays(habit);

    if (tracking == 0) {
      return 0;
    }

    final weeks = tracking / 7;

    if (weeks <= 1) {
      return logs.length.toDouble();
    }

    return logs.length / weeks;
  }

  //--------------------------------------------------------
  // Tracking Days
  //--------------------------------------------------------

  int trackingDays(
      Habit habit,
      ) {
    final days =
        DateTime.now()
            .difference(
          habit.createdAt,
        )
            .inDays +
            1;

    return days < 1 ? 1 : days;
  }

  //--------------------------------------------------------
  // Active Days
  //--------------------------------------------------------

  int activeDays(
      List<HabitLogEntity> logs,
      ) {
    final unique = logs
        .map(
          (log) => DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      ),
    )
        .toSet();

    return unique.length;
  }

  //--------------------------------------------------------
  // Longest Gap
  //--------------------------------------------------------

  int longestGap(
      List<HabitLogEntity> logs,
      ) {
    if (logs.length < 2) {
      return 0;
    }

    final sorted = [...logs]
      ..sort(
            (a, b) => a.date.compareTo(
          b.date,
        ),
      );

    var gap = 0;

    for (var i = 1;
    i < sorted.length;
    i++) {
      final days =
          sorted[i]
              .date
              .difference(
            sorted[i - 1].date,
          )
              .inDays -
              1;

      if (days > gap) {
        gap = days;
      }
    }

    return gap;
  }

  //--------------------------------------------------------
  // Weekly Progress
  //--------------------------------------------------------

  WeeklyProgress weeklyProgress(
      List<HabitLogEntity> logs,
      ) {
    final today = DateTime.now();

    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(
      const Duration(days: 6),
    );

    final items = <WeekDayProgress>[];

    var completed = 0;

    for (var i = 0; i < 7; i++) {
      final date = start.add(
        Duration(days: i),
      );

      final done = logs.any(
            (log) =>
        _sameDay(
          log.date,
          date,
        ) &&
            log.status ==
                CompletionStatus.completed,
      );

      if (done) {
        completed++;
      }

      items.add(
        WeekDayProgress(
          day: _weekday(date),
          completed: done,
          isToday: _sameDay(
            date,
            today,
          ),
          date: date,
        ),
      );
    }

    return WeeklyProgress(
      days: items,
      completedCount: completed,
    );
  }

  //--------------------------------------------------------
  // Monthly Progress
  //--------------------------------------------------------

  MonthlyProgress monthlyProgress(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final now = DateTime.now();

    final completed = logs
        .where(
          (log) =>
      log.date.month ==
          now.month &&
          log.date.year ==
              now.year &&
          log.status ==
              CompletionStatus.completed,
    )
        .length;

    final totalDays =
        DateTime(
          now.year,
          now.month + 1,
          0,
        ).day;

    final elapsed = now.day;

    final missed =
        elapsed - completed;

    return MonthlyProgress(
      month: now.month,
      year: now.year,
      completedDays: completed,
      missedDays:
      missed < 0 ? 0 : missed,
      targetDays: totalDays,
      completionRate:
      elapsed == 0
          ? 0
          : completed / elapsed,
    );
  }

  //--------------------------------------------------------
  // Heatmap
  //--------------------------------------------------------

  List<HeatmapDay> buildHeatmap(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final heatmap = <HeatmapDay>[];

    final today = DateTime.now();

    for (var i = 364; i >= 0; i--) {
      final date = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(
        Duration(days: i),
      );

      final count = logs.where(
            (log) {
          return _sameDay(
            log.date,
            date,
          ) &&
              log.status ==
                  CompletionStatus.completed;
        },
      ).length;

      heatmap.add(
        HeatmapDay(
          date: date,
          count: count,
        ),
      );
    }

    return heatmap;
  }

  //--------------------------------------------------------
  // Helpers
  //--------------------------------------------------------

  bool _sameDay(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String _weekday(
      DateTime date,
      ) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'M';

      case DateTime.tuesday:
        return 'T';

      case DateTime.wednesday:
        return 'W';

      case DateTime.thursday:
        return 'T';

      case DateTime.friday:
        return 'F';

      case DateTime.saturday:
        return 'S';

      case DateTime.sunday:
        return 'S';

      default:
        return '';
    }
  }
}