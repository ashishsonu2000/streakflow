import '../repositories/habit_repository.dart';

class RebuildHabitStatisticsUseCase {
  const RebuildHabitStatisticsUseCase(
    this._repository,
  );

  final HabitRepository _repository;

  Future<void> call() {
    return _repository.rebuildHabitStatistics();
  }
}
