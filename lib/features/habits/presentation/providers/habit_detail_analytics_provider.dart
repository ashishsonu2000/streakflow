import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/analytics/habit_details_analytics.dart';
import '../../domain/models/habit.dart';

import '../../domain/usecases/get_habit_detail_analytics_usecase.dart';

import '../provider/habit_providers.dart';

final getHabitDetailAnalyticsUseCaseProvider =
Provider(
      (ref) {
    return GetHabitDetailAnalyticsUseCase(
      ref.read(
        habitRepositoryProvider,
      ),
    );
  },
);

final habitDetailAnalyticsProvider =
FutureProvider.family<
    HabitDetailAnalytics,
    Habit>(
      (
      ref,
      habit,
      ) {
    return ref
        .read(
      getHabitDetailAnalyticsUseCaseProvider,
    )
        .call(
      habit,
    );
  },
);