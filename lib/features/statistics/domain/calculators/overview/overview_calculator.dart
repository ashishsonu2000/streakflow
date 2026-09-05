import '../../../../../core/utils/date_utils.dart';

import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';
import '../../models/overview_statistics.dart';

import 'perfect_day_calculator.dart';
import 'streak_calculator.dart';

class OverviewCalculator
    implements Calculator<StatisticsContext, OverviewStatistics> {
  const OverviewCalculator();

  @override
  OverviewStatistics calculate(
      StatisticsContext context,
      ) {
    // =========================================================
    // TODAY
    // =========================================================

    final today = AppDateUtils.today;

    final todayLogs =
        context.completedLogsByDate[today] ?? const [];

    // =========================================================
    // TODAY'S COMPLETED HABITS
    //
    // Use unique habit IDs so multiple logs for the same habit
    // don't artificially increase today's completion count.
    // =========================================================

    final completedToday = todayLogs
        .map((log) => log.habitId)
        .toSet()
        .length;

    // =========================================================
    // TODAY'S EXPECTED HABITS
    //
    // This is recurrence-aware:
    //
    // Daily   -> every active day
    // Weekly  -> only selected weekdays
    // Monthly -> only selected monthly day
    // =========================================================

    final totalToday =
    context.expectedHabitsForDate(today);

    // =========================================================
    // TODAY'S COMPLETION RATE
    // =========================================================

    final completionRate = totalToday == 0
        ? 0.0
        : (completedToday / totalToday)
        .clamp(0.0, 1.0);

    // =========================================================
    // TODAY'S XP
    // =========================================================

    final todayXP = todayLogs.fold<int>(
      0,
          (sum, log) => sum + log.xpEarned,
    );

    // =========================================================
    // TODAY'S DURATION
    // =========================================================

    final todayDuration = todayLogs.fold<int>(
      0,
          (sum, log) => sum + log.durationMinutes,
    );

    // =========================================================
    // STREAK
    //
    // Keep streak based on the complete history.
    //
    // The overview does not have a single habit, so preserve
    // the existing calendar-wide streak calculation.
    // =========================================================

    final streak =
    const StreakCalculator().calculate(
      context.logs,
    );

    // =========================================================
    // PERFECT DAYS
    // =========================================================

    final perfectDays =
    const PerfectDayCalculator().calculate(
      context,
    );

    // =========================================================
    // RESULT
    // =========================================================

    return OverviewStatistics(
      // Today's completion
      completionRate: completionRate,

      // Historical streak
      currentStreak: streak.currentStreak,
      bestStreak: streak.longestStreak,

      // Active habits
      totalHabits: context.activeHabitCount,

      // Today's completions
      totalCompletions: completedToday,

      // Today's XP
      totalXP: todayXP,

      // Today's duration
      totalDurationMinutes: todayDuration,

      // Existing perfect-day calculation
      perfectDays: perfectDays,
    );
  }
}