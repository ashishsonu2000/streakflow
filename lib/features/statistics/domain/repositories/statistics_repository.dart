import '../models/statistics_summary.dart';

abstract interface class StatisticsRepository {
  Future<StatisticsSummary> getStatistics();
}
