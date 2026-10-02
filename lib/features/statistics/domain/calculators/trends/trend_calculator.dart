import '../../../../../core/models/completion_trend.dart';
import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';

class TrendCalculator
    implements
        Calculator<
            StatisticsContext,
            List<CompletionTrend>
        > {
  const TrendCalculator();

  @override
  List<CompletionTrend> calculate(
      StatisticsContext context,
      ) {
    final trends = <CompletionTrend>[];

    final today = DateTime.now();

    for (var i = 29; i >= 0; i--) {
      // Calendar arithmetic so daylight-saving days can't shift dates.
      final date = DateTime(
        today.year,
        today.month,
        today.day - i,
      );

      // Due habits completed / habits due that day (completed logs
      // only; weekly/monthly habits only count on their days).
      final expected =
          context.expectedHabitsForDate(date);

      final completionRate =
      expected == 0
          ? 0.0
          : context.completedScheduledCountForDate(date) /
          expected;

      trends.add(
        CompletionTrend(
          date: date,
          completionRate:
          completionRate.clamp(
            0.0,
            1.0,
          ),
        ),
      );
    }

    return trends;
  }
}