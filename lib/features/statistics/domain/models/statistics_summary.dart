import '../../../../core/models/completion_trend.dart';

import '../../../habits/domain/models/habit_log.dart';

import 'category_distribution.dart';
import 'habit_performance.dart';
import 'insight.dart';
import 'monthly_statistics.dart';
import 'overview_statistics.dart';
import 'weekly_statistics.dart';
import 'yearly_statistics.dart';
import 'xp_trend.dart';

class StatisticsSummary {
  const StatisticsSummary({
    required this.overview,
    required this.weekly,
    required this.monthly,
    required this.yearly,
    required this.trends,
    required this.performance,
    required this.insights,
    required this.logs,
    required this.categoryDistribution,
    required this.xpTrend,
  });

  // ===============================================================
  // OVERVIEW
  // ===============================================================

  final OverviewStatistics overview;

  // ===============================================================
  // WEEKLY
  // ===============================================================

  final WeeklyStatistics weekly;

  // ===============================================================
  // MONTHLY
  // ===============================================================

  final MonthlyStatistics monthly;

  // ===============================================================
  // YEARLY
  // ===============================================================

  final YearlyStatistics yearly;

  // ===============================================================
  // TRENDS
  // ===============================================================

  final List<CompletionTrend> trends;

  // ===============================================================
  // HABIT PERFORMANCE
  // ===============================================================

  final List<HabitPerformance> performance;

  // ===============================================================
  // INSIGHTS
  // ===============================================================

  final List<Insight> insights;

  // ===============================================================
  // LOGS
  // ===============================================================

  final List<HabitLog> logs;

  // ===============================================================
  // CATEGORY DISTRIBUTION
  // ===============================================================

  final List<CategoryDistribution>
  categoryDistribution;

  // ===============================================================
  // XP TREND
  // ===============================================================

  final List<XPTrend> xpTrend;
}