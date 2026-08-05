import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';

class PerfectDayCalculator implements Calculator<StatisticsContext, int> {
  const PerfectDayCalculator();

  @override
  int calculate(
    StatisticsContext context,
  ) {
    final totalHabits = context.habits.length;

    if (totalHabits == 0) {
      return 0;
    }

    return context.logsByDate.values
        .where(
          (logs) => logs.length >= totalHabits,
        )
        .length;
  }
}
