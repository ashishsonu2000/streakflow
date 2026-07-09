import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';
import '../../domain/habit_summary_mapper.dart';
import '../../domain/mappers/dashboard_view_model_mapper.dart';
import '../../domain/models/dashboard_view_model.dart';
import '../../domain/services/dashboard_analytics_service.dart';
import 'dashboard_action_provider.dart';

final dashboardAnalyticsProvider = Provider<DashboardAnalyticsService>((ref) {
  return const DashboardAnalyticsService();
});

final dashboardViewModelMapperProvider =
    Provider<DashboardViewModelMapper>((ref) {
  return const DashboardViewModelMapper();
});

final dashboardViewModelProvider =
    Provider<AsyncValue<DashboardViewModel>>((ref) {
  final habitsAsync = ref.watch(habitsProvider);
  final logsAsync = ref.watch(habitLogsProvider);

  final analyticsService = ref.watch(
    dashboardAnalyticsProvider,
  );

  final mapper = ref.watch(
    dashboardViewModelMapperProvider,
  );

  final actions = ref.watch(
    dashboardActionsProvider,
  );

  const summaryMapper = HabitSummaryMapper();

  return habitsAsync.when(
    loading: () => const AsyncLoading(),
    error: (error, stack) => AsyncError(
      error,
      stack,
    ),
    data: (habits) {
      return logsAsync.when(
        loading: () => const AsyncLoading(),
        error: (error, stack) => AsyncError(
          error,
          stack,
        ),
        data: (logs) {
          final analytics = analyticsService.calculate(
            habits,
            logs,
          );

          final summaries = habits.map(summaryMapper.toSummary).toList();

          final dashboard = mapper.map(
            analytics,
            summaries,
            actions,
            "Ashish", // TODO: Read from ProfileRepository later
          );

          return AsyncData(
            dashboard,
          );
        },
      );
    },
  );
});
