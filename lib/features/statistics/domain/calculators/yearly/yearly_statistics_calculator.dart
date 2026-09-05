import '../../../../../core/utils/date_utils.dart';

import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';
import '../../models/yearly_statistics.dart';

class YearlyStatisticsCalculator
    implements Calculator<
        StatisticsContext,
        YearlyStatistics
    > {
  const YearlyStatisticsCalculator();

  // ===============================================================
  // MAIN CALCULATION
  // ===============================================================

  @override
  YearlyStatistics calculate(
      StatisticsContext context,
      ) {
    // -------------------------------------------------------------
    // Selected year
    // -------------------------------------------------------------
    //
    // IMPORTANT:
    // Use StatisticsQuery -> StatisticsContext.selectedDate.
    //
    // Do NOT always use DateTime.now().
    //

    final selectedDate =
    AppDateUtils.dateOnly(
      context.selectedDate,
    );

    final today =
        AppDateUtils.today;

    final year =
        selectedDate.year;

    // =============================================================
    // MONTHS
    // =============================================================

    final months =
    <YearlyMonthStatistics>[];

    // =============================================================
    // YEAR TOTALS
    // =============================================================

    var yearlyScheduled = 0;
    var yearlyCompleted = 0;
    var yearlyXP = 0;
    var yearlyDuration = 0;
    var yearlyPerfectDays = 0;

    // =============================================================
    // CALCULATE 12 MONTHS
    // =============================================================

    for (var month = 1;
    month <= 12;
    month++) {
      // -----------------------------------------------------------
      // Start of month
      // -----------------------------------------------------------

      final monthStart = DateTime(
        year,
        month,
        1,
      );

      // -----------------------------------------------------------
      // End of month
      // -----------------------------------------------------------

      final monthEnd = DateTime(
        year,
        month + 1,
        0,
      );

      // -----------------------------------------------------------
      // Future month
      // -----------------------------------------------------------
      //
      // Only suppress future months when viewing the current year.
      //
      // Previous years must contain all 12 months.
      //

      final isFutureMonth =
          year == today.year &&
              monthStart.isAfter(today);

      if (isFutureMonth) {
        months.add(
          YearlyMonthStatistics(
            month: month,
            completionRate: 0.0,
            totalScheduled: 0,
            totalCompleted: 0,
            totalMissed: 0,
            totalXP: 0,
            totalDurationMinutes: 0,
            perfectDays: 0,
          ),
        );

        continue;
      }

      // -----------------------------------------------------------
      // Effective end
      // -----------------------------------------------------------
      //
      // Current year -> stop at today.
      //
      // Previous year -> use complete month.
      //

      final effectiveEnd =
      year == today.year &&
          monthEnd.isAfter(today)
          ? today
          : monthEnd;

      // -----------------------------------------------------------
      // Month totals
      // -----------------------------------------------------------

      var scheduled = 0;
      var completed = 0;
      var xp = 0;
      var duration = 0;
      var perfectDays = 0;

      // ===========================================================
      // EACH DAY
      // ===========================================================

      for (
      var day =
      AppDateUtils.dateOnly(
        monthStart,
      );
      !day.isAfter(
        effectiveEnd,
      );
      day = day.add(
        const Duration(days: 1),
      )
      ) {
        // ---------------------------------------------------------
        // Expected occurrences
        // ---------------------------------------------------------

        final expected =
        context.expectedHabitsForDate(
          day,
        );

        // ---------------------------------------------------------
        // Completed logs
        // ---------------------------------------------------------

        final logs =
            context.completedLogsByDate[
            day] ??
                const [];

        // ---------------------------------------------------------
        // Unique completed habits
        // ---------------------------------------------------------

        final completedHabitIds =
        <String>{};

        var dayXP = 0;
        var dayDuration = 0;

        for (final log in logs) {
          completedHabitIds.add(
            log.habitId,
          );

          dayXP +=
              log.xpEarned;

          dayDuration +=
              log.durationMinutes;
        }

        final dayCompleted =
            completedHabitIds.length;

        // ---------------------------------------------------------
        // Aggregate
        // ---------------------------------------------------------

        scheduled += expected;

        completed +=
            dayCompleted;

        xp += dayXP;

        duration +=
            dayDuration;

        // ---------------------------------------------------------
        // Perfect day
        // ---------------------------------------------------------

        if (expected > 0 &&
            dayCompleted >=
                expected) {
          perfectDays++;
        }
      }

      // ===========================================================
      // MONTH MISSED
      // ===========================================================

      final missed = (
          scheduled -
              completed
      ).clamp(
        0,
        scheduled,
      );

      // ===========================================================
      // MONTH COMPLETION
      // ===========================================================

      final completionRate =
      scheduled == 0
          ? 0.0
          : (
          completed /
              scheduled
      ).clamp(
        0.0,
        1.0,
      );

      // ===========================================================
      // MONTH RESULT
      // ===========================================================

      final monthStatistics =
      YearlyMonthStatistics(
        month: month,
        completionRate:
        completionRate,
        totalScheduled:
        scheduled,
        totalCompleted:
        completed,
        totalMissed:
        missed,
        totalXP: xp,
        totalDurationMinutes:
        duration,
        perfectDays:
        perfectDays,
      );

      months.add(
        monthStatistics,
      );

      // ===========================================================
      // YEAR TOTALS
      // ===========================================================

      yearlyScheduled +=
          scheduled;

      yearlyCompleted +=
          completed;

      yearlyXP += xp;

      yearlyDuration +=
          duration;

      yearlyPerfectDays +=
          perfectDays;
    }

    // =============================================================
    // YEAR MISSED
    // =============================================================

    final yearlyMissed = (
        yearlyScheduled -
            yearlyCompleted
    ).clamp(
      0,
      yearlyScheduled,
    );

    // =============================================================
    // YEAR COMPLETION RATE
    // =============================================================

    final yearlyCompletionRate =
    yearlyScheduled == 0
        ? 0.0
        : (
        yearlyCompleted /
            yearlyScheduled
    ).clamp(
      0.0,
      1.0,
    );

    // =============================================================
    // RESULT
    // =============================================================

    return YearlyStatistics(
      year: year,
      completionRate:
      yearlyCompletionRate,
      totalScheduled:
      yearlyScheduled,
      totalCompleted:
      yearlyCompleted,
      totalMissed:
      yearlyMissed,
      totalXP: yearlyXP,
      totalDurationMinutes:
      yearlyDuration,
      perfectDays:
      yearlyPerfectDays,
      months: months,
    );
  }
}