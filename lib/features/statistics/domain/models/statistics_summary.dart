import 'completion_trend.dart';
import 'habit_performance.dart';
import 'insight.dart';
import 'monthly_statistics.dart';
import 'overview_statistics.dart';
import 'weekly_statistics.dart';

class StatisticsSummary {
  const StatisticsSummary({
    required this.overview,
    required this.weekly,
    required this.monthly,
    required this.trends,
    required this.performance,
    required this.insights,
  });

  final OverviewStatistics overview;

  final WeeklyStatistics weekly;

  final MonthlyStatistics monthly;

  final List<CompletionTrend> trends;

  final List<HabitPerformance> performance;

  final List<Insight> insights;
}
