import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit_log.dart';

import 'habit_providers.dart';

final habitLogsProvider =
StreamProvider.family<
    List<HabitLog>,
    String>(
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