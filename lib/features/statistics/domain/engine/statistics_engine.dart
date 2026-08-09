import '../models/statistics_summary.dart';

import '../calculators/overview/overview_calculator.dart';
import '../calculators/weekly/weekly_statistics_calculator.dart';
import '../calculators/monthly/monthly_statistics_calculator.dart';
import '../calculators/performance/performance_calculator.dart';
import '../calculators/trends/trend_calculator.dart';
import '../calculators/insights/insight_calculator.dart';
import 'statistics_context.dart';

class StatisticsEngine {
  const StatisticsEngine({
    this.overviewCalculator = const OverviewCalculator(),
    this.weeklyCalculator = const WeeklyStatisticsCalculator(),
    this.monthlyCalculator = const MonthlyStatisticsCalculator(),
    this.performanceCalculator = const PerformanceCalculator(),
    this.trendCalculator = const TrendCalculator(),
    this.insightCalculator = const InsightCalculator(),
  });

  final OverviewCalculator overviewCalculator;
  final WeeklyStatisticsCalculator weeklyCalculator;
  final MonthlyStatisticsCalculator monthlyCalculator;
  final PerformanceCalculator performanceCalculator;
  final TrendCalculator trendCalculator;
  final InsightCalculator insightCalculator;

  StatisticsSummary calculate(
      StatisticsContext context,
      ) {
    return StatisticsSummary(
      overview: overviewCalculator.calculate(context),
      weekly: weeklyCalculator.calculate(context),
      monthly: monthlyCalculator.calculate(context),
      performance: performanceCalculator.calculate(context),
      trends: trendCalculator.calculate(context),
      insights: insightCalculator.calculate(context),
      logs: const [], // ✅ TEMP (will be overridden in repository)
    );
  }
}