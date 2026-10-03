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

class HabitStatisticsQuery {
  const HabitStatisticsQuery({
    required this.habitId,
    required this.date,
  });

  final String habitId;
  final DateTime date;

  @override
  bool operator ==(Object other) {
    return other is HabitStatisticsQuery &&
        other.habitId == habitId &&
        other.date.year == date.year &&
        other.date.month == date.month &&
        other.date.day == date.day;
  }

  @override
  int get hashCode => Object.hash(
    habitId,
    date.year,
    date.month,
    date.day,
  );
}

final habitStatisticsProvider =
FutureProvider.family<
    HabitStatistics?,
    HabitStatisticsQuery>(
      (ref, query) async {
    final useCase =
    ref.read(
      getHabitStatisticsUseCaseProvider,
    );

    return useCase(
      query.habitId,
      selectedDate: query.date,
    );
  },
);