import '../models/statistics_summary.dart';
import '../repositories/statistics_repository.dart';

class GetStatisticsUseCase {
  const GetStatisticsUseCase(
    this._repository,
  );

  final StatisticsRepository _repository;

  Future<StatisticsSummary> call() {
    return _repository.getStatistics();
  }
}
