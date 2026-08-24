import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/providers/dashboard_provider.dart';

import '../providers/habit_stream_provider.dart';
import 'habit_statistics_provider.dart';

void refreshHabitDependentData(
    Ref ref,
    ) {
  ref.invalidate(habitsProvider);
  ref.invalidate(dashboardProvider);
  ref.invalidate(habitStatisticsProvider);
}