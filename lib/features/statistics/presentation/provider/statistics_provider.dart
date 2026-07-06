import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/domain/services/dashboard_analytics_service.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../habits/presentation/provider/habit_providers.dart';
import '../../domain/models/statistics_summary.dart';
import '../../domain/services/statistics_service.dart';

final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  return const StatisticsService();
});

final statisticsProvider = Provider<AsyncValue<StatisticsSummary>>((ref) {
  final habitsAsync = ref.watch(habitsProvider);
  final logsAsync = ref.watch(habitLogsProvider);

  final analyticsService = ref.watch(
    dashboardAnalyticsProvider,
  );

  final statisticsService = ref.watch(
    statisticsServiceProvider,
  );

  return habitsAsync.when(
    loading: () => const AsyncLoading(),
    error: (e, s) => AsyncError(e, s),
    data: (habits) {
      return logsAsync.when(
        loading: () => const AsyncLoading(),
        error: (e, s) => AsyncError(e, s),
        data: (logs) {
          final analytics = analyticsService.calculate(
            habits,
            logs,
          );

          final statistics = statisticsService.calculate(
            analytics,
            habits,
          );

          return AsyncData(statistics);
        },
      );
    },
  );
});
