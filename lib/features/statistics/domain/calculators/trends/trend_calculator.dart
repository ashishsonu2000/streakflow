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
      final date = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(
        Duration(
          days: i,
        ),
      );

      final logs =
          context.logsByDate[date] ??
              const [];

      final completed =
          logs.length;

      final completionRate =
      context.habits.isEmpty
          ? 0.0
          : completed /
          context.habits.length;

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