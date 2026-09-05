import '../../../../../core/utils/date_utils.dart';

import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';
import '../../models/monthly_statistics.dart';

class MonthlyStatisticsCalculator
    implements Calculator<StatisticsContext, MonthlyStatistics> {
  const MonthlyStatisticsCalculator();

  // ===============================================================
  // MAIN CALCULATION
  // ===============================================================

  @override
  MonthlyStatistics calculate(
      StatisticsContext context,
      ) {
    // -------------------------------------------------------------
    // Selected month
    // -------------------------------------------------------------
    //
    // IMPORTANT:
    // The Statistics page supplies context.selectedDate through
    // StatisticsQuery.
    //
    // Therefore this calculator must NOT always use DateTime.now().
    //

    final selectedDate = AppDateUtils.dateOnly(
      context.selectedDate,
    );

    // =============================================================
    // SELECTED MONTH
    // =============================================================

    final selectedMonthStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      1,
    );

    final selectedMonthEnd = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    );

    // -------------------------------------------------------------
    // Do not include future dates in the current month.
    // -------------------------------------------------------------

    final today = AppDateUtils.today;

    final selectedMonthIsCurrentMonth =
        selectedDate.year == today.year &&
            selectedDate.month == today.month;

    final selectedMonthCalculationEnd =
    selectedMonthIsCurrentMonth &&
        selectedMonthEnd.isAfter(today)
        ? today
        : selectedMonthEnd;

    final selectedMonthResult = _calculateMonth(
      context,
      selectedMonthStart,
      selectedMonthCalculationEnd,
    );

    // =============================================================
    // PREVIOUS MONTH
    // =============================================================

    final previousMonthStart = DateTime(
      selectedMonthStart.year,
      selectedMonthStart.month - 1,
      1,
    );

    final previousMonthEnd = DateTime(
      selectedMonthStart.year,
      selectedMonthStart.month,
      0,
    );

    final previousMonthResult = _calculateMonth(
      context,
      previousMonthStart,
      previousMonthEnd,
    );

    // =============================================================
    // MONTH-OVER-MONTH CHANGE
    // =============================================================

    final change =
        (selectedMonthResult.completionRate -
            previousMonthResult.completionRate) *
            100;

    // =============================================================
    // RESULT
    // =============================================================

    return MonthlyStatistics(
      monthlyCompletionRate:
      selectedMonthResult.completionRate,

      totalScheduled:
      selectedMonthResult.totalScheduled,

      totalCompleted:
      selectedMonthResult.totalCompleted,

      totalMissed:
      selectedMonthResult.totalMissed,

      totalXP:
      selectedMonthResult.totalXP,

      totalDurationMinutes:
      selectedMonthResult.totalDurationMinutes,

      perfectDays:
      selectedMonthResult.perfectDays,

      previousMonthCompletionRate:
      previousMonthResult.completionRate,

      monthlyChangePercentage:
      double.parse(
        change.toStringAsFixed(2),
      ),
    );
  }

  // ===============================================================
  // CALCULATE ONE MONTH
  // ===============================================================

  _MonthResult _calculateMonth(
      StatisticsContext context,
      DateTime start,
      DateTime end,
      ) {
    var totalScheduled = 0;
    var totalCompleted = 0;
    var totalXP = 0;
    var totalDuration = 0;
    var perfectDays = 0;

    final normalizedStart =
    AppDateUtils.dateOnly(start);

    final normalizedEnd =
    AppDateUtils.dateOnly(end);

    // -------------------------------------------------------------
    // Empty range
    // -------------------------------------------------------------

    if (normalizedEnd.isBefore(
      normalizedStart,
    )) {
      return const _MonthResult(
        completionRate: 0.0,
        totalScheduled: 0,
        totalCompleted: 0,
        totalMissed: 0,
        totalXP: 0,
        totalDurationMinutes: 0,
        perfectDays: 0,
      );
    }

    // =============================================================
    // EACH DAY
    // =============================================================

    for (
    var day = normalizedStart;
    !day.isAfter(normalizedEnd);
    day = day.add(
      const Duration(days: 1),
    )
    ) {
      // -----------------------------------------------------------
      // Expected scheduled occurrences
      // -----------------------------------------------------------
      //
      // StatisticsContext handles:
      //
      // Daily
      // Weekly
      // Monthly
      // Custom
      // Start date
      // End date
      //

      final expected =
      context.expectedHabitsForDate(
        day,
      );

      // -----------------------------------------------------------
      // Completed logs
      // -----------------------------------------------------------

      final logs =
          context.completedLogsByDate[
          day] ??
              const [];

      // -----------------------------------------------------------
      // Count each habit only once per day
      // -----------------------------------------------------------

      final completedHabitIds =
      <String>{};

      var dayXP = 0;
      var dayDuration = 0;

      for (final log in logs) {
        completedHabitIds.add(
          log.habitId,
        );

        dayXP += log.xpEarned;

        dayDuration +=
            log.durationMinutes;
      }

      final completed =
          completedHabitIds.length;

      // ===========================================================
      // AGGREGATE
      // ===========================================================

      totalScheduled += expected;

      totalCompleted += completed;

      totalXP += dayXP;

      totalDuration += dayDuration;

      // ===========================================================
      // PERFECT DAY
      // ===========================================================

      if (expected > 0 &&
          completed >= expected) {
        perfectDays++;
      }
    }

    // =============================================================
    // MISSED
    // =============================================================

    final missed = (
        totalScheduled -
            totalCompleted
    ).clamp(
      0,
      totalScheduled,
    );

    // =============================================================
    // COMPLETION RATE
    // =============================================================

    final completionRate =
    totalScheduled == 0
        ? 0.0
        : (
        totalCompleted /
            totalScheduled
    ).clamp(
      0.0,
      1.0,
    );

    // =============================================================
    // RESULT
    // =============================================================

    return _MonthResult(
      completionRate: completionRate,
      totalScheduled: totalScheduled,
      totalCompleted: totalCompleted,
      totalMissed: missed,
      totalXP: totalXP,
      totalDurationMinutes:
      totalDuration,
      perfectDays: perfectDays,
    );
  }
}

// ===============================================================
// INTERNAL MONTH RESULT
// ===============================================================

class _MonthResult {
  const _MonthResult({
    required this.completionRate,
    required this.totalScheduled,
    required this.totalCompleted,
    required this.totalMissed,
    required this.totalXP,
    required this.totalDurationMinutes,
    required this.perfectDays,
  });

  final double completionRate;

  final int totalScheduled;

  final int totalCompleted;

  final int totalMissed;

  final int totalXP;

  final int totalDurationMinutes;

  final int perfectDays;
}