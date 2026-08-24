import '../models/habit_statistics.dart';
import '../repositories/habit_repository.dart';
import '../services/habit_analytics_service.dart';

class GetHabitStatisticsUseCase {
  const GetHabitStatisticsUseCase(
      this._repository,
      this._analytics,
      );

  final HabitRepository _repository;
  final HabitAnalyticsService _analytics;

  Future<HabitStatistics?> call(
      String habitId,
      ) async {
    final habit = await _repository.getById(habitId);

    if (habit == null) {
      return null;
    }

    final logs =
    await _repository.getHabitLogsForHabit(habitId);

    return _analytics.buildStatistics(
      habit,
      logs,
    );
  }
}