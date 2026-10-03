import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit_log.dart';
import 'habit_providers.dart';

/// ===============================================================
/// Logs for a single habit
/// ===============================================================

final habitLogsProvider =
StreamProvider.family<List<HabitLog>, String>(
      (
      ref,
      habitId,
      ) {
    return ref
        .read(
      habitRepositoryProvider,
    )
        .watchLogsForHabit(
      habitId,
    );
  },
);

/// ===============================================================
/// All habit logs
/// ===============================================================
///
/// Used by Calendar and other screens that need historical
/// activity across all habits.

final allHabitLogsProvider =
StreamProvider<List<HabitLog>>(
      (ref) {
    return ref
        .read(
      habitRepositoryProvider,
    )
        .watchLogs();
  },
);