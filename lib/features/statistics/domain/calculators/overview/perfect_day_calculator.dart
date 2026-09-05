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

    final today = DateTime.now();

    final start = DateTime(
      today.year,
      today.month,
      1,
    );

    var perfectDays = 0;

    for (
    var day = start;
    !day.isAfter(today);
    day = day.add(
      const Duration(days: 1),
    )
    ) {
      final expected =
      context.expectedHabitsForDate(day);

      if (expected == 0) {
        continue;
      }

      final logs =
          context.completedLogsByDate[day] ??
              const [];

      final completedIds = logs
          .map((log) => log.habitId)
          .toSet();

      if (completedIds.length >= expected) {
        perfectDays++;
      }
    }

    return perfectDays;
  }
}