import 'package:isar_community/isar.dart';

import '../../domain/enums/completion_status.dart';
import '../entities/habit_log_entity.dart';

/// Day-level lookups of a habit's completion log.
extension HabitLogQueries on IsarCollection<HabitLogEntity> {
  /// The first log of [habitId] dated on [day] (a date-only value).
  Future<HabitLogEntity?> findForDay(
      String habitId,
      DateTime day,
      ) {
    return filter()
        .habitIdEqualTo(habitId)
        .dateBetween(
      day,
      day.add(
        const Duration(days: 1),
      ),
      includeUpper: false,
    )
        .findFirst();
  }

  /// Whether the log of [habitId] on [day] is a completion.
  Future<bool> isCompletedOn(
      String habitId,
      DateTime day,
      ) async {
    final log = await findForDay(
      habitId,
      day,
    );

    return log != null &&
        log.status ==
            CompletionStatus.completed;
  }
}
