import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit_statistics.dart';
import '../../domain/services/habit_analytics_service.dart';
import '../../domain/usecases/get_habit_statistics_usecase.dart';

import '../providers/habit_repository_provider.dart';

final habitAnalyticsServiceProvider =
Provider<HabitAnalyticsService>(
      (ref) {
    return const HabitAnalyticsService();
  },
);

final getHabitStatisticsUseCaseProvider =
Provider<GetHabitStatisticsUseCase>(
      (ref) {
    return GetHabitStatisticsUseCase(
      ref.read(habitRepositoryProvider),
      ref.read(habitAnalyticsServiceProvider),
    );
  },
);

final habitStatisticsProvider =
FutureProvider.family<HabitStatistics?, String>(
      (ref, habitId) async {
    final useCase =
    ref.read(getHabitStatisticsUseCaseProvider);

    return useCase(habitId);
  },
);