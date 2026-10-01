import '../../../habits/domain/models/habit.dart';

/// Which reminder times a habit gets, given the plan's limit.
///
/// Pure (no plugins), so the rules are unit tested directly.
abstract final class ReminderTimes {
  static const minutesPerDay = 24 * 60;

  /// Minutes since midnight to schedule, primary reminder first.
  ///
  /// Empty when reminders are off or the primary time is missing or
  /// invalid. Extra times are de-duplicated, never equal the primary
  /// time, are sorted, and are capped at [maxReminders] in total.
  static List<int> resolve(Habit habit, {required int maxReminders}) {
    final hour = habit.reminderHour;
    final minute = habit.reminderMinute;

    if (!habit.reminderEnabled ||
        hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59 ||
        maxReminders < 1) {
      return const [];
    }

    final primary = hour * 60 + minute;

    final extras = habit.additionalReminderMinutes
        .where((m) => m >= 0 && m < minutesPerDay && m != primary)
        .toSet()
        .toList()
      ..sort();

    return [primary, ...extras.take(maxReminders - 1)];
  }
}

/// Notification IDs for habit reminders.
///
/// Slot 0 (the primary reminder) keeps the IDs used by earlier app
/// versions, so reminders scheduled before this update stay valid and
/// cancellable. Extra slots use a stable FNV-1a hash (identical across
/// app runs and Dart versions).
abstract final class ReminderIds {
  /// Highest slot index any plan can use.
  static const maxSlots = 5;

  /// Repeating daily reminder for an ongoing habit.
  static int recurring(String habitId, int slot) {
    if (slot == 0) {
      return habitId.hashCode.abs();
    }
    return _stable('$habitId#reminder$slot');
  }

  /// One-off reminder for [date] (habits with an end date).
  static int forDate(String habitId, DateTime date, int slot) {
    final key = '$habitId-${date.year}-${date.month}-${date.day}';
    if (slot == 0) {
      return key.hashCode.abs();
    }
    return _stable('$key#reminder$slot');
  }

  /// Payload attached to every habit reminder, used to find and cancel
  /// all of a habit's notifications.
  static String payload(String habitId) => 'habit:$habitId';

  static int _stable(String value) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    // Positive 31-bit, as Android notification IDs are Java ints.
    return hash & 0x7FFFFFFF;
  }
}
