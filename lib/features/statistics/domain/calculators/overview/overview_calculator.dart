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
    //------------------------------------------
    // Streak
    //------------------------------------------

    final streak = const StreakCalculator().calculate(
      context.logs,
    );

    //------------------------------------------
    // Perfect Days
    //------------------------------------------

    final perfectDays = const PerfectDayCalculator().calculate(
      context,
    );

    //------------------------------------------
    // XP
    //------------------------------------------

    final totalXP = context.logs.fold<int>(
      0,
      (sum, log) => sum + log.xpEarned,
    );

    //------------------------------------------
    // Duration
    //------------------------------------------

    final totalDuration = context.logs.fold<int>(
      0,
      (sum, log) => sum + log.durationMinutes,
    );

    //------------------------------------------
    // Today's Completion
    //------------------------------------------

    final today = AppDateUtils.today;

    final completedToday = (context.completedLogsByDate[today] ?? const [])
        .map((log) => log.habitId)
        .toSet()
        .length;

    final totalToday = context.expectedHabitsForDate(today);

    final completionRate =
        totalToday == 0 ? 0.0 : (completedToday / totalToday).clamp(0.0, 1.0);

    return OverviewStatistics(
      completionRate: completionRate,
      currentStreak: streak.currentStreak,
      bestStreak: streak.longestStreak,
      totalHabits: context.activeHabitCount,
      totalCompletions: completedToday,
      totalXP: totalXP,
      totalDurationMinutes: totalDuration,
      perfectDays: perfectDays,
    );
  }
}
