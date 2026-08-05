import '../../../../../core/utils/date_utils.dart';
import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';
import '../../models/monthly_statistics.dart';

class MonthlyStatisticsCalculator
    implements Calculator<StatisticsContext, MonthlyStatistics> {
  const MonthlyStatisticsCalculator();

  @override
  MonthlyStatistics calculate(
    StatisticsContext context,
  ) {
    final today = AppDateUtils.today;

    final monthStart = AppDateUtils.startOfMonth(today);

    var totalCompleted = 0;
    var totalExpected = 0;
    var totalXP = 0;
    var totalDuration = 0;
    var perfectDays = 0;

    for (var day = monthStart;
        !day.isAfter(today);
        day = day.add(const Duration(days: 1))) {
      final logs = context.completedLogsByDate[day] ?? const [];

      final completedHabitIds = <String>{};

      var xp = 0;
      var duration = 0;

      for (final log in logs) {
        completedHabitIds.add(log.habitId);
        xp += log.xpEarned;
        duration += log.durationMinutes;
      }

      final completed = completedHabitIds.length;

      final expected = context.expectedHabitsForDate(day);

      totalCompleted += completed;
      totalExpected += expected;
      totalXP += xp;
      totalDuration += duration;

      if (expected > 0 && completed >= expected) {
        perfectDays++;
      }
    }

    final completionRate =
        totalExpected == 0 ? 0.0 : totalCompleted / totalExpected;

    return MonthlyStatistics(
      monthlyCompletionRate: completionRate,
      totalCompleted: totalCompleted,
      totalXP: totalXP,
      totalDurationMinutes: totalDuration,
      perfectDays: perfectDays,
    );
  }
}
