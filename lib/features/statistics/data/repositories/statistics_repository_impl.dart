import '../../../habits/domain/repositories/habit_repository.dart';

import '../../domain/engine/statistics_context.dart';
import '../../domain/engine/statistics_engine.dart';
import '../../domain/models/statistics_summary.dart';
import '../../domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl(
    this._habitRepository,
    this._engine,
  );

  final HabitRepository _habitRepository;
  final StatisticsEngine _engine;

  @override
  Future<StatisticsSummary> getStatistics() async {
    final habits = await _habitRepository.getAll();
    final logs = await _habitRepository.getLogs();

    final context = StatisticsContext(
      habits: habits,
      logs: logs,
    );

    return _engine.calculate(context);
  }
}
