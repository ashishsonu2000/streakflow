import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';

import '../../data/repositories/statistics_repository_impl.dart';
import '../../domain/engine/statistics_engine.dart';
import '../../domain/models/statistics_summary.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../domain/usecases/get_statistics_usecase.dart';

/// Engine
final statisticsEngineProvider = Provider<StatisticsEngine>(
  (ref) => const StatisticsEngine(),
);

/// Repository
final statisticsRepositoryProvider = Provider<StatisticsRepository>(
  (ref) {
    return StatisticsRepositoryImpl(
      ref.read(habitRepositoryProvider),
      ref.read(statisticsEngineProvider),
    );
  },
);

/// UseCase
final getStatisticsUseCaseProvider = Provider<GetStatisticsUseCase>(
  (ref) {
    return GetStatisticsUseCase(
      ref.read(statisticsRepositoryProvider),
    );
  },
);

/// UI Provider
final statisticsProvider = FutureProvider<StatisticsSummary>((ref) async {
  return ref.read(statisticsRepositoryProvider).getStatistics();
});
