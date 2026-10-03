import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../habits/presentation/provider/filtered_habits_provider.dart';
import '../../../habits/presentation/provider/habit_providers.dart';
import '../../../statistics/presentation/provider/statistics_provider.dart';
import '../../domain/builders/dashboard_mapper.dart';
import '../../domain/models/dashboard_view_model.dart';

class DashboardNotifier
    extends AsyncNotifier<DashboardViewModel> {
  @override
  Future<DashboardViewModel> build() async {
    // =============================================================
    // HABITS
    // =============================================================

    final habits =
        ref.watch(filteredHabitsProvider).value ?? [];

    // Recent Activity names completions of any habit, including ones
    // not due today, hidden by the Habits page filter, or archived.
    final allHabits = [
      ...ref.watch(allActiveHabitsProvider).value ?? const [],
      ...ref.watch(archivedHabitsProvider).value ?? const [],
    ];

    // =============================================================
    // CALENDAR
    // =============================================================

    final calendar =
        ref.watch(calendarProvider).value;

    if (calendar == null) {
      throw Exception(
        'Calendar not ready',
      );
    }

    // =============================================================
    // STATISTICS
    // =============================================================
    //
    // statisticsProvider is a FutureProvider.family.
    //
    // Therefore it must always be called with a StatisticsQuery.
    //
    // The dashboard uses the current/default statistics snapshot.
    //

    final statistics = await ref.watch(
      statisticsProvider(
        StatisticsQuery(
          date: DateTime.now(),
        ),
      ).future,
    );

    // =============================================================
    // MAP DASHBOARD
    // =============================================================

    return DashboardMapper().map(
      statistics,
      habits: habits,
      activityHabits: allHabits,
      calendar: calendar,
      logs: statistics.logs,
    );
  }
}