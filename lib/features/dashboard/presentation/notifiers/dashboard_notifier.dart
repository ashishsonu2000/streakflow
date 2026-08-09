import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../habits/presentation/provider/filtered_habits_provider.dart';
import '../../../statistics/presentation/provider/statistics_provider.dart';
import '../../domain/builders/dashboard_mapper.dart';
import '../../domain/models/dashboard_view_model.dart';

class DashboardNotifier extends AsyncNotifier<DashboardViewModel> {
  @override
  Future<DashboardViewModel> build() async {
    final habits = ref.watch(filteredHabitsProvider).value ?? [];
    final calendar = ref.watch(calendarProvider).value;

    if (calendar == null) {
      throw Exception("Calendar not ready");
    }

    final statistics = await ref.watch(statisticsProvider.future);

    return DashboardMapper().map(
      statistics,
      habits: habits,
      calendar: calendar,
      logs: statistics.logs,
    );
  }
}