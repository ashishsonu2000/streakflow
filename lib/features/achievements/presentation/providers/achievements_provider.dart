import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../statistics/presentation/provider/statistics_provider.dart';

import '../../domain/models/achievement.dart';
import '../../domain/services/achievement_builder.dart';

/// ===============================================================
/// ACHIEVEMENTS PROVIDER
/// ===============================================================
///
/// Builds achievements from the current statistics snapshot.
///
/// The statistics provider is a FutureProvider.family, so a
/// StatisticsQuery must be supplied when watching it.
///

final achievementProvider =
Provider<AsyncValue<List<Achievement>>>(
      (ref) {
    // =============================================================
    // STATISTICS
    // =============================================================

    final statistics = ref.watch(
      statisticsProvider(
        const StatisticsQuery(),
      ),
    );

    // =============================================================
    // STATISTICS STATE
    // =============================================================

    return statistics.when(
      // -----------------------------------------------------------
      // LOADING
      // -----------------------------------------------------------

      loading: () {
        return const AsyncLoading<
            List<Achievement>>();
      },

      // -----------------------------------------------------------
      // ERROR
      // -----------------------------------------------------------

      error: (
          error,
          stackTrace,
          ) {
        return AsyncError<List<Achievement>>(
          error,
          stackTrace,
        );
      },

      // -----------------------------------------------------------
      // DATA
      // -----------------------------------------------------------

      data: (summary) {
        final achievements =
        const AchievementBuilder().build(
          summary,
        );

        return AsyncData<
            List<Achievement>>(
          achievements,
        );
      },
    );
  },
);