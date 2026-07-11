import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/analytics_summary.dart';
import 'habit_providers.dart';

final habitAnalyticsProvider = FutureProvider.family<AnalyticsSummary, String>(
  (ref, habitId) {
    return ref.read(getHabitAnalyticsUseCaseProvider).call(habitId);
  },
);
