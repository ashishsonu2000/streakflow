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

/// Query used to load statistics for a specific habit/date.
class HabitStatisticsQuery {
  const HabitStatisticsQuery({
    required this.habitId,
    this.date,
  });

  final String habitId;
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
        other is HabitStatisticsQuery &&
            other.habitId == habitId &&
            other.selectedDate == selectedDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      habitId,
      selectedDate,
    );
  }
}

final habitStatisticsProvider =
FutureProvider.family<HabitStatistics?, HabitStatisticsQuery>(
      (ref, query) async {
    final useCase =
    ref.read(getHabitStatisticsUseCaseProvider);

    return useCase(
      query.habitId,
      selectedDate: query.selectedDate,
    );
  },
);