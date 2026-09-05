import 'package:flutter/foundation.dart';

import '../../../../../core/utils/date_utils.dart';
import '../../../../habits/domain/models/habit_log.dart';

import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';

import '../../models/weekday_statistics.dart';
import '../../models/weekly_statistics.dart';
import '../../models/weekly_trend.dart';

class WeeklyStatisticsCalculator
    implements Calculator<StatisticsContext, WeeklyStatistics> {
  const WeeklyStatisticsCalculator();

  // ===============================================================
  // MAIN CALCULATION
  // ===============================================================

  @override
  WeeklyStatistics calculate(
      StatisticsContext context,
      ) {
    // -------------------------------------------------------------
    // Selected week
    // -------------------------------------------------------------
    //
    // IMPORTANT:
    // Do not use DateTime.now() here.
    //
    // StatisticsQuery supplies context.selectedDate, which allows
    // the Statistics page to display previous/next weeks.
    //

    final selectedDate = AppDateUtils.dateOnly(
      context.selectedDate,
    );

    final weekStart = _startOfWeek(
      selectedDate,
    );

    // -------------------------------------------------------------
    // Selected week
    // -------------------------------------------------------------

    final days = _buildWeek(
      context,
      weekStart,
    );

    // -------------------------------------------------------------
    // Previous week
    // -------------------------------------------------------------

    final previousWeekStart = weekStart.subtract(
      const Duration(days: 7),
    );

    final previousWeek = _buildWeek(
      context,
      previousWeekStart,
    );

    // -------------------------------------------------------------
    // Selected week totals
    // -------------------------------------------------------------

    final totalCompleted = days.fold<int>(
      0,
          (
          sum,
          day,
          ) =>
      sum + day.completedHabits,
    );

    final totalTarget = days.fold<int>(
      0,
          (
          sum,
          day,
          ) =>
      sum + day.targetHabits,
    );

    final totalXP = days.fold<int>(
      0,
          (
          sum,
          day,
          ) =>
      sum + day.totalXP,
    );

    final totalDuration = days.fold<int>(
      0,
          (
          sum,
          day,
          ) =>
      sum + day.totalDurationMinutes,
    );

    final activeDays = days
        .where(
          (day) => day.hasActivity,
    )
        .length;

    // -------------------------------------------------------------
    // Completion rate
    // -------------------------------------------------------------

    final completionRate = _round4(
      totalTarget == 0
          ? 0.0
          : totalCompleted / totalTarget,
    );

    // -------------------------------------------------------------
    // Previous week totals
    // -------------------------------------------------------------

    final previousCompleted =
    previousWeek.fold<int>(
      0,
          (
          sum,
          day,
          ) =>
      sum + day.completedHabits,
    );

    final previousTarget =
    previousWeek.fold<int>(
      0,
          (
          sum,
          day,
          ) =>
      sum + day.targetHabits,
    );

    final previousCompletionRate = _round4(
      previousTarget == 0
          ? 0.0
          : previousCompleted / previousTarget,
    );

    // -------------------------------------------------------------
    // Week-over-week change
    // -------------------------------------------------------------

    final change =
        (completionRate -
            previousCompletionRate) *
            100;

    // -------------------------------------------------------------
    // Debug
    // -------------------------------------------------------------

    debugPrint(
      '========== WEEKLY STATISTICS ==========',
    );

    debugPrint(
      'Selected Date   : $selectedDate',
    );

    debugPrint(
      'Week Start      : $weekStart',
    );

    debugPrint(
      'Days Considered : ${days.length}',
    );

    debugPrint(
      'Completed       : $totalCompleted',
    );

    debugPrint(
      'Target          : $totalTarget',
    );

    debugPrint(
      'Completion Rate : '
          '${(completionRate * 100).toStringAsFixed(1)}%',
    );

    debugPrint(
      'Active Days     : $activeDays',
    );

    debugPrint(
      'Previous Rate   : '
          '${(previousCompletionRate * 100).toStringAsFixed(1)}%',
    );

    debugPrint(
      'Change          : '
          '${change.toStringAsFixed(1)}%',
    );

    debugPrint(
      '========================================',
    );

    // -------------------------------------------------------------
    // Result
    // -------------------------------------------------------------

    return WeeklyStatistics(
      days: days,
      completionRate: completionRate,
      previousWeekCompletionRate:
      previousCompletionRate,
      weeklyChangePercentage: change,
      trend: _trend(change),
      totalCompleted: totalCompleted,
      totalTarget: totalTarget,
      totalXP: totalXP,
      totalDurationMinutes: totalDuration,
      activeDays: activeDays,
      bestDay: _bestDay(days),
      worstDay: _worstDay(days),
    );
  }

  // ===============================================================
  // BUILD WEEK
  // ===============================================================

  List<WeekdayStatistics> _buildWeek(
      StatisticsContext context,
      DateTime weekStart,
      ) {
    final days = <WeekdayStatistics>[];

    for (var i = 0; i < 7; i++) {
      final day = AppDateUtils.dateOnly(
        weekStart.add(
          Duration(days: i),
        ),
      );

      // -----------------------------------------------------------
      // Do not generate statistics for dates after today.
      //
      // This applies only to the current/future week.
      //
      // For a previous week all seven days are generated.
      // -----------------------------------------------------------

      final today = AppDateUtils.dateOnly(
        DateTime.now(),
      );

      if (day.isAfter(today)) {
        break;
      }

      days.add(
        _buildDay(
          context,
          day,
        ),
      );
    }

    return days;
  }

  // ===============================================================
  // BUILD DAY
  // ===============================================================

  WeekdayStatistics _buildDay(
      StatisticsContext context,
      DateTime day,
      ) {
    final normalizedDay =
    AppDateUtils.dateOnly(day);

    // -------------------------------------------------------------
    // Completed logs
    // -------------------------------------------------------------

    final logs =
        context.completedLogsByDate[
        normalizedDay] ??
            const <HabitLog>[];

    // -------------------------------------------------------------
    // Count each habit only once per day.
    // -------------------------------------------------------------

    final completedHabitIds =
    <String>{};

    var xp = 0;
    var duration = 0;

    for (final log in logs) {
      completedHabitIds.add(
        log.habitId,
      );

      xp += log.xpEarned;

      duration +=
          log.durationMinutes;
    }

    final completed =
        completedHabitIds.length;

    // -------------------------------------------------------------
    // Expected habits
    // -------------------------------------------------------------

    final target =
    context.expectedHabitsForDate(
      normalizedDay,
    );

    // -------------------------------------------------------------
    // Completion
    // -------------------------------------------------------------

    final completionRate =
    target == 0
        ? 0.0
        : (completed / target)
        .clamp(0.0, 1.0);

    // -------------------------------------------------------------
    // Perfect day
    // -------------------------------------------------------------

    final isPerfectDay =
        target > 0 &&
            completed >= target;

    return WeekdayStatistics(
      date: normalizedDay,
      completedHabits: completed,
      targetHabits: target,
      completionRate: completionRate,
      totalXP: xp,
      totalDurationMinutes: duration,
      isPerfectDay: isPerfectDay,
    );
  }

  // ===============================================================
  // START OF WEEK
  // ===============================================================
  //
  // Monday = first day of week.
  //
  // Dart:
  // Monday    = 1
  // Tuesday   = 2
  // ...
  // Sunday    = 7
  //

  DateTime _startOfWeek(
      DateTime date,
      ) {
    final normalized =
    AppDateUtils.dateOnly(date);

    return normalized.subtract(
      Duration(
        days: normalized.weekday - 1,
      ),
    );
  }

  // ===============================================================
  // BEST DAY
  // ===============================================================

  WeekdayStatistics _bestDay(
      List<WeekdayStatistics> days,
      ) {
    if (days.isEmpty) {
      return _emptyDay();
    }

    return days.reduce(
          (
          a,
          b,
          ) {
        // Higher completion rate wins.
        if (b.completionRate >
            a.completionRate) {
          return b;
        }

        // If equal, higher XP wins.
        if (b.completionRate ==
            a.completionRate &&
            b.totalXP > a.totalXP) {
          return b;
        }

        return a;
      },
    );
  }

  // ===============================================================
  // WORST DAY
  // ===============================================================

  WeekdayStatistics _worstDay(
      List<WeekdayStatistics> days,
      ) {
    if (days.isEmpty) {
      return _emptyDay();
    }

    return days.reduce(
          (
          a,
          b,
          ) {
        // Lower completion rate wins as worst day.
        if (b.completionRate <
            a.completionRate) {
          return b;
        }

        // If equal, lower XP wins.
        if (b.completionRate ==
            a.completionRate &&
            b.totalXP < a.totalXP) {
          return b;
        }

        return a;
      },
    );
  }

  // ===============================================================
  // EMPTY DAY
  // ===============================================================

  WeekdayStatistics _emptyDay() {
    return WeekdayStatistics(
      date: AppDateUtils.dateOnly(
        DateTime.now(),
      ),
      completedHabits: 0,
      targetHabits: 0,
      completionRate: 0.0,
      totalXP: 0,
      totalDurationMinutes: 0,
      isPerfectDay: false,
    );
  }

  // ===============================================================
  // TREND
  // ===============================================================

  static const double _trendThreshold = 2.0;

  WeeklyTrend _trend(
      double change,
      ) {
    if (change > _trendThreshold) {
      return WeeklyTrend.improving;
    }

    if (change < -_trendThreshold) {
      return WeeklyTrend.declining;
    }

    return WeeklyTrend.stable;
  }

  // ===============================================================
  // ROUND
  // ===============================================================

  double _round4(
      double value,
      ) {
    return double.parse(
      value.toStringAsFixed(4),
    );
  }
}