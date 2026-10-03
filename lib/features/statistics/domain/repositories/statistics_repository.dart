import '../models/statistics_summary.dart';

abstract class StatisticsRepository {
  Future<StatisticsSummary> getStatistics({
    DateTime? date,
  });
}