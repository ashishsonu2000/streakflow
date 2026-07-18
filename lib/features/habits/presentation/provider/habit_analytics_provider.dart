import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/habit_analytics_service.dart';

final habitAnalyticsServiceProvider = Provider<HabitAnalyticsService>(
  (ref) => HabitAnalyticsService(),
);
