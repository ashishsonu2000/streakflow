import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../statistics/presentation/provider/statistics_provider.dart';

import '../../domain/models/achievement.dart';
import '../../domain/services/achievement_builder.dart';

final achievementProvider =
Provider<AsyncValue<List<Achievement>>>(
      (ref) {
    final statistics = ref.watch(
      statisticsProvider,
    );

    return statistics.when(
      loading: () {
        return const AsyncLoading();
      },
      error: (error, stackTrace) {
        return AsyncError(
          error,
          stackTrace,
        );
      },
      data: (summary) {
        final achievements =
        const AchievementBuilder().build(
          summary,
        );

        return AsyncData<List<Achievement>>(
          achievements,
        );
      },
    );
  },
);