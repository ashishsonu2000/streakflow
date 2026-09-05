import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';

import '../../data/repositories/statistics_repository_impl.dart';
import '../../domain/engine/statistics_engine.dart';
import '../../domain/models/statistics_summary.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../domain/usecases/get_statistics_usecase.dart';

/// ===============================================================
/// STATISTICS QUERY
/// ===============================================================

class StatisticsQuery {
  const StatisticsQuery({
    this.date,
  });

  final DateTime? date;

  DateTime get selectedDate {
    final value = date ?? DateTime.now();

    return DateTime(
      value.year,
      value.month,
      value.day,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StatisticsQuery &&
            selectedDate == other.selectedDate;
  }

  @override
  int get hashCode => selectedDate.hashCode;

  @override
  String toString() {
    return 'StatisticsQuery(date: $selectedDate)';
  }
}

/// ===============================================================
/// ENGINE
/// ===============================================================

final statisticsEngineProvider =
Provider<StatisticsEngine>(
      (ref) {
    return const StatisticsEngine();
  },
);

/// ===============================================================
/// REPOSITORY
/// ===============================================================

final statisticsRepositoryProvider =
Provider<StatisticsRepository>(
      (ref) {
    return StatisticsRepositoryImpl(
      ref.read(habitRepositoryProvider),
      ref.read(statisticsEngineProvider),
    );
  },
);

/// ===============================================================
/// USE CASE
/// ===============================================================

final getStatisticsUseCaseProvider =
Provider<GetStatisticsUseCase>(
      (ref) {
    return GetStatisticsUseCase(
      ref.read(statisticsRepositoryProvider),
    );
  },
);

/// ===============================================================
/// GLOBAL STATISTICS
/// ===============================================================

final statisticsProvider =
FutureProvider.family<
    StatisticsSummary,
    StatisticsQuery>(
      (ref, query) async {
    return ref
        .read(statisticsRepositoryProvider)
        .getStatistics(
      date: query.selectedDate,
    );
  },
);