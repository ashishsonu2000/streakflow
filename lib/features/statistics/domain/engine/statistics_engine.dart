import '../calculators/insights/insight_calculator.dart';
import '../calculators/monthly/monthly_statistics_calculator.dart';
import '../calculators/overview/overview_calculator.dart';
import '../calculators/performance/performance_calculator.dart';
import '../calculators/trends/trend_calculator.dart';
import '../calculators/weekly/weekly_statistics_calculator.dart';

import '../models/category_distribution.dart';
import '../models/statistics_summary.dart';

import '../models/xp_trend.dart';
import 'statistics_context.dart';

class StatisticsEngine {
  const StatisticsEngine({
    this.overviewCalculator =
    const OverviewCalculator(),
    this.weeklyCalculator =
    const WeeklyStatisticsCalculator(),
    this.monthlyCalculator =
    const MonthlyStatisticsCalculator(),
    this.performanceCalculator =
    const PerformanceCalculator(),
    this.trendCalculator =
    const TrendCalculator(),
    this.insightCalculator =
    const InsightCalculator(),
  });

  final OverviewCalculator
  overviewCalculator;

  final WeeklyStatisticsCalculator
  weeklyCalculator;

  final MonthlyStatisticsCalculator
  monthlyCalculator;

  final PerformanceCalculator
  performanceCalculator;

  final TrendCalculator
  trendCalculator;

  final InsightCalculator
  insightCalculator;

  StatisticsSummary calculate(
      StatisticsContext context,
      ) {
    final trends =
    trendCalculator.calculate(
      context,
    );

    final categoryDistribution =
    <CategoryDistribution>[];

    final totalHabits =
        context.habits.length;

    for (final category
    in context.habits
        .map((h) => h.category)
        .toSet()) {
      final count = context.habits
          .where(
            (habit) =>
        habit.category ==
            category,
      )
          .length;

      categoryDistribution.add(
        CategoryDistribution(
          category: category,
          count: count,
          percentage:
          totalHabits == 0
              ? 0
              : count /
              totalHabits,
        ),
      );
    }

    final sortedLogs = [
      ...context.logs,
    ]..sort(
          (a, b) =>
          a.date.compareTo(
            b.date,
          ),
    );

    final xpTrend = <XPTrend>[];

    var cumulativeXp = 0;

    for (final log in sortedLogs) {
      cumulativeXp += log.xpEarned;

      xpTrend.add(
        XPTrend(
          date: log.date,
          xp: log.xpEarned,
          cumulativeXp:
          cumulativeXp,
        ),
      );
    }

    return StatisticsSummary(
      overview:
      overviewCalculator.calculate(
        context,
      ),
      weekly:
      weeklyCalculator.calculate(
        context,
      ),
      monthly:
      monthlyCalculator.calculate(
        context,
      ),
      performance:
      performanceCalculator.calculate(
        context,
      ),
      trends: trends,
      insights:
      insightCalculator.calculate(
        context,
      ),
      logs: context.logs,
      categoryDistribution:
      categoryDistribution,
      xpTrend: xpTrend,
    );
  }
}