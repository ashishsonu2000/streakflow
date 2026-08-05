import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';

import '../../models/completion_trend.dart';

class TrendCalculator
    implements Calculator<StatisticsContext, List<CompletionTrend>> {
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
        Duration(days: i),
      );

      final logs = context.logsByDate[date] ?? const [];

      final completed = logs.length;

      final completionRate =
          context.habits.isEmpty ? 0.0 : completed / context.habits.length;

      final xp = logs.fold<int>(
        0,
        (sum, log) => sum + log.xpEarned,
      );

      final duration = logs.fold<int>(
        0,
        (sum, log) => sum + log.durationMinutes,
      );

      trends.add(
        CompletionTrend(
          date: date,
          completed: completed,
          total: context.habits.length,
          completionRate: completionRate,
          xp: xp,
          durationMinutes: duration,
        ),
      );
    }

    return trends;
  }
}
