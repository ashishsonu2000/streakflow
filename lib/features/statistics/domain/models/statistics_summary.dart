import '../../../../core/models/completion_trend.dart';

import '../../../habits/domain/models/habit_log.dart';

import 'category_distribution.dart';
import 'habit_performance.dart';
import 'insight.dart';
import 'monthly_statistics.dart';
import 'overview_statistics.dart';
import 'weekly_statistics.dart';
import 'xp_trend.dart';

class StatisticsSummary {
  const StatisticsSummary({
    required this.overview,
    required this.weekly,
    required this.monthly,
    required this.trends,
    required this.performance,
    required this.insights,
    required this.logs,
    required this.categoryDistribution,
    required this.xpTrend,
  });

  final OverviewStatistics overview;

  final WeeklyStatistics weekly;

  final MonthlyStatistics monthly;

  final List<CompletionTrend> trends;

  final List<HabitPerformance> performance;

  final List<Insight> insights;

  final List<HabitLog> logs;

  final List<CategoryDistribution>
  categoryDistribution;

  final List<XPTrend> xpTrend;
}