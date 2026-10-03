import '../calculators/insights/insight_calculator.dart';
import '../calculators/monthly/monthly_statistics_calculator.dart';
import '../calculators/overview/overview_calculator.dart';
import '../calculators/performance/performance_calculator.dart';
import '../calculators/trends/trend_calculator.dart';
import '../calculators/weekly/weekly_statistics_calculator.dart';
import '../calculators/yearly/yearly_statistics_calculator.dart';

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

    this.yearlyCalculator =
    const YearlyStatisticsCalculator(),

    this.performanceCalculator =
    const PerformanceCalculator(),

    this.trendCalculator =
    const TrendCalculator(),

    this.insightCalculator =
    const InsightCalculator(),
  });

  // ===============================================================
  // CALCULATORS
  // ===============================================================

  final OverviewCalculator
  overviewCalculator;

  final WeeklyStatisticsCalculator
  weeklyCalculator;

  final MonthlyStatisticsCalculator
  monthlyCalculator;

  final YearlyStatisticsCalculator
  yearlyCalculator;

  final PerformanceCalculator
  performanceCalculator;

  final TrendCalculator
  trendCalculator;

  final InsightCalculator
  insightCalculator;

  // ===============================================================
  // CALCULATE
  // ===============================================================

  StatisticsSummary calculate(
      StatisticsContext context,
      ) {
    // =============================================================
    // WEEKLY
    // =============================================================

    final weekly =
    weeklyCalculator.calculate(
      context,
    );

    // =============================================================
    // MONTHLY
    // =============================================================

    final monthly =
    monthlyCalculator.calculate(
      context,
    );

    // =============================================================
    // YEARLY
    // =============================================================

    final yearly =
    yearlyCalculator.calculate(
      context,
    );

    // =============================================================
    // OVERVIEW
    // =============================================================

    final overview =
    overviewCalculator.calculate(
      context,
    );

    // =============================================================
    // PERFORMANCE
    // =============================================================

    final performance =
    performanceCalculator.calculate(
      context,
    );

    // =============================================================
    // TRENDS
    // =============================================================

    final trends =
    trendCalculator.calculate(
      context,
    );

    // =============================================================
    // INSIGHTS
    // =============================================================

    final insights =
    insightCalculator.calculate(
      context,
    );

    // =============================================================
    // CATEGORY DISTRIBUTION
    // =============================================================

    final categoryDistribution =
    _buildCategoryDistribution(
      context,
    );

    // =============================================================
    // XP TREND
    // =============================================================

    final xpTrend =
    _buildXpTrend(
      context,
    );

    // =============================================================
    // RESULT
    // =============================================================

    return StatisticsSummary(
      overview: overview,
      weekly: weekly,
      monthly: monthly,
      yearly: yearly,
      trends: trends,
      performance: performance,
      insights: insights,
      logs: context.logs,
      categoryDistribution:
      categoryDistribution,
      xpTrend: xpTrend,
    );
  }

  // ===============================================================
  // CATEGORY DISTRIBUTION
  // ===============================================================

  List<CategoryDistribution>
  _buildCategoryDistribution(
      StatisticsContext context,
      ) {
    final result =
    <CategoryDistribution>[];

    // -------------------------------------------------------------
    // Use active habits for the distribution.
    //
    // Archived habits should not influence the current statistics
    // dashboard.
    // -------------------------------------------------------------

    final activeHabits =
        context.activeHabits;

    final totalHabits =
        activeHabits.length;

    if (totalHabits == 0) {
      return result;
    }

    final categories =
    activeHabits
        .map(
          (habit) => habit.category,
    )
        .toSet();

    for (final category in categories) {
      final count =
          activeHabits
              .where(
                (habit) =>
            habit.category ==
                category,
          )
              .length;

      result.add(
        CategoryDistribution(
          category: category,
          count: count,
          percentage:
          count / totalHabits,
        ),
      );
    }

    // -------------------------------------------------------------
    // Stable ordering
    // -------------------------------------------------------------

    result.sort(
          (a, b) =>
          b.count.compareTo(
            a.count,
          ),
    );

    return result;
  }

  // ===============================================================
  // XP TREND
  // ===============================================================

  List<XPTrend> _buildXpTrend(
      StatisticsContext context,
      ) {
    final sortedLogs = [
      ...context.completedLogs,
    ]..sort(
          (a, b) =>
          a.date.compareTo(
            b.date,
          ),
    );

    final result =
    <XPTrend>[];

    var cumulativeXp = 0;

    for (final log in sortedLogs) {
      cumulativeXp +=
          log.xpEarned;

      result.add(
        XPTrend(
          date: log.date,
          xp: log.xpEarned,
          cumulativeXp:
          cumulativeXp,
        ),
      );
    }

    return result;
  }
}