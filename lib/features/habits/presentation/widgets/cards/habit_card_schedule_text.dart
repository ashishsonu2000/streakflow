import 'package:intl/intl.dart';

import '../../../domain/models/habit.dart';
import '../../../domain/models/habit_schedule_status.dart';

/// Card text for a habit that isn't due today, e.g.
/// "Not due today · next on Tue, 6 Oct".
String notDueTodayMessage(Habit habit) {
  final next = habit.nextDueDate;

  if (next == null) {
    return 'Not due today · no more days scheduled.';
  }

  return 'Not due today · next on ${DateFormat('EEE, d MMM').format(next)}';
}
