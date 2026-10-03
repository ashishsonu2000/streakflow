import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';

class PerfectDayCalculator
    implements Calculator<StatisticsContext, int> {
  const PerfectDayCalculator();

  @override
  int calculate(
      StatisticsContext context,
      ) {
    if (context.habits.isEmpty) {
      return 0;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final start = DateTime(
      today.year,
      today.month,
      1,
    );

    var perfectDays = 0;

    for (
    var day = start;
    !day.isAfter(today);
    day = DateTime(day.year, day.month, day.day + 1)
    ) {
      final expected =
      context.expectedHabitsForDate(day);

      if (expected == 0) {
        continue;
      }

      if (context.completedScheduledCountForDate(day) >= expected) {
        perfectDays++;
      }
    }

    return perfectDays;
  }
}