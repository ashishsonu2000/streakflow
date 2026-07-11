import '../domain/models/analytics_summary.dart';
import '../domain/repositories/habit_repository.dart';

class GetHabitAnalyticsUseCase {
  const GetHabitAnalyticsUseCase(
    this._repository,
  );

  final HabitRepository _repository;

  Future<AnalyticsSummary> call(
    String habitId,
  ) {
    return _repository.getAnalytics(
      habitId,
    );
  }
}
