import '../../../habits/domain/enums/habit_frequency.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/services/habit_schedule_service.dart';

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

  /// Repeating reminder on one weekday (1 = Monday ... 7 = Sunday) for
  /// weekly habits.
  static int weekly(String habitId, int weekday, int slot) =>
      _stable('$habitId#weekday$weekday#reminder$slot');

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

/// How a scheduled reminder repeats after it first fires.
enum ReminderRepeat {
  /// Fires once.
  none,

  /// Every day at the same time.
  daily,

  /// Every week on the same weekday and time.
  weekly,

  /// Every month on the same day and time. Android skips months without
  /// that day (e.g. the 31st), matching the habit's own schedule.
  monthly,
}

/// One notification to schedule.
class ReminderEntry {
  const ReminderEntry({
    required this.id,
    required this.slot,
    required this.at,
    required this.repeat,
  });

  final int id;

  /// Index into the habit's reminder times (0 = primary).
  final int slot;

  /// First time it fires (local wall-clock time).
  final DateTime at;

  final ReminderRepeat repeat;

  int get minuteOfDay => at.hour * 60 + at.minute;

  @override
  String toString() => 'ReminderEntry($id, slot $slot, $at, ${repeat.name})';
}

/// Turns a habit and its reminder times into notifications.
///
/// Reminders follow the habit's schedule: daily habits every day,
/// weekly habits only on their weekdays, monthly habits on their day of
/// the month.
///
/// Repeating notifications are used wherever possible, so a habit needs
/// at most one alarm per reminder time (per weekday for weekly habits),
/// however long it runs. Android caps an app at about 500 alarms.
///
/// Repeats cannot stop at an end date, so once a habit has at most
/// [finalOccurrences] scheduled days left before its end date, those
/// remaining reminders are scheduled individually instead (at most
/// finalOccurrences x reminder times alarms). Habits with an end date
/// are rescheduled at every app launch (see
/// reminderEntitlementSyncProvider) to make that switch, and to remove
/// their reminders after they end.
///
/// Pure (no plugins), so the rules are unit tested directly.
abstract final class ReminderPlanner {
  /// Remaining scheduled days at which reminders switch to one-offs.
  static const finalOccurrences = 7;

  /// How far ahead to look for a habit's first occurrence. Monthly
  /// habits on the 31st can be two months away.
  static const _searchDays = 400;

  static const _schedule = HabitScheduleService();

  /// Notifications for [habit] with reminder [times] (minutes since
  /// midnight, index = slot; see [ReminderTimes.resolve]), as of [now].
  ///
  /// Empty when there is nothing left to remind about (no times, habit
  /// ended, or no future occurrence).
  static List<ReminderEntry> plan(
    Habit habit,
    List<int> times, {
    required DateTime now,
  }) {
    if (times.isEmpty) {
      return const [];
    }

    final today = _dateOnly(now);
    final start = _dateOnly(habit.startDate);
    final from = start.isAfter(today) ? start : today;
    final end = habit.endDate == null ? null : _dateOnly(habit.endDate!);

    if (end != null && end.isBefore(from)) {
      return const [];
    }

    if (end != null) {
      final remaining = _scheduledDays(
        habit,
        from: from,
        end: end,
        limit: finalOccurrences + 1,
      );

      if (remaining.length <= finalOccurrences) {
        return _oneOffs(habit, times, days: remaining, now: now);
      }
    }

    return _repeating(habit, times, from: from, end: end, now: now);
  }

  // =========================================================
  // Repeating
  // =========================================================

  static List<ReminderEntry> _repeating(
    Habit habit,
    List<int> times, {
    required DateTime from,
    required DateTime? end,
    required DateTime now,
  }) {
    final entries = <ReminderEntry>[];

    void add({
      required int id,
      required int slot,
      required ReminderRepeat repeat,
      required bool Function(DateTime day) matches,
    }) {
      final first = _firstAfter(
        from: from,
        minute: times[slot],
        now: now,
        matches: matches,
      );

      // A repeat must not start after the habit has ended.
      if (first == null || (end != null && _dateOnly(first).isAfter(end))) {
        return;
      }

      entries.add(
        ReminderEntry(id: id, slot: slot, at: first, repeat: repeat),
      );
    }

    final weekdays = _weekdays(habit);

    for (var slot = 0; slot < times.length; slot++) {
      if (weekdays != null) {
        for (final weekday in weekdays) {
          add(
            id: ReminderIds.weekly(habit.id, weekday, slot),
            slot: slot,
            repeat: ReminderRepeat.weekly,
            matches: (day) => day.weekday == weekday,
          );
        }
      } else if (habit.frequency == HabitFrequency.monthly) {
        final monthlyDay = habit.monthlyDay;
        if (monthlyDay < 1 || monthlyDay > 31) {
          continue;
        }
        add(
          id: ReminderIds.recurring(habit.id, slot),
          slot: slot,
          repeat: ReminderRepeat.monthly,
          matches: (day) => day.day == monthlyDay,
        );
      } else {
        // Daily, custom (scheduled every day), and weekly habits that
        // run every day of the week.
        add(
          id: ReminderIds.recurring(habit.id, slot),
          slot: slot,
          repeat: ReminderRepeat.daily,
          matches: (_) => true,
        );
      }
    }

    return entries;
  }

  /// The weekdays of a weekly habit, or null when it should repeat
  /// daily instead (not weekly, or every day of the week).
  static List<int>? _weekdays(Habit habit) {
    if (habit.frequency != HabitFrequency.weekly) {
      return null;
    }

    // Same rule as HabitScheduleService: weekly habits created before
    // weekday selection existed run on their start date's weekday.
    final days = habit.weeklyDays.isEmpty
        ? {habit.startDate.weekday}
        : habit.weeklyDays.where((d) => d >= 1 && d <= 7).toSet();

    if (days.length == 7) {
      return null;
    }

    return days.toList()..sort();
  }

  // =========================================================
  // One-offs (final occurrences before the end date)
  // =========================================================

  /// Scheduled days of [habit] from [from] to [end], at most [limit].
  static List<DateTime> _scheduledDays(
    Habit habit, {
    required DateTime from,
    required DateTime end,
    required int limit,
  }) {
    final days = <DateTime>[];

    for (var day = from;
        !day.isAfter(end) && days.length < limit;
        day = _nextDay(day)) {
      if (_schedule.isScheduledIgnoringArchived(habit, day)) {
        days.add(day);
      }
    }

    return days;
  }

  static List<ReminderEntry> _oneOffs(
    Habit habit,
    List<int> times, {
    required List<DateTime> days,
    required DateTime now,
  }) {
    final entries = <ReminderEntry>[];

    for (final day in days) {
      for (var slot = 0; slot < times.length; slot++) {
        final at = _at(day, times[slot]);
        if (!at.isAfter(now)) {
          continue;
        }

        entries.add(
          ReminderEntry(
            id: ReminderIds.forDate(habit.id, day, slot),
            slot: slot,
            at: at,
            repeat: ReminderRepeat.none,
          ),
        );
      }
    }

    return entries;
  }

  // =========================================================
  // Helpers
  // =========================================================

  /// First day from [from] matching [matches] whose reminder time is
  /// still ahead of [now].
  static DateTime? _firstAfter({
    required DateTime from,
    required int minute,
    required DateTime now,
    required bool Function(DateTime day) matches,
  }) {
    var day = from;
    for (var i = 0; i < _searchDays; i++, day = _nextDay(day)) {
      if (!matches(day)) {
        continue;
      }
      final at = _at(day, minute);
      if (at.isAfter(now)) {
        return at;
      }
    }
    return null;
  }

  static DateTime _at(DateTime day, int minute) =>
      DateTime(day.year, day.month, day.day, minute ~/ 60, minute % 60);

  // Calendar arithmetic (not Duration) so DST changes cannot shift days.
  static DateTime _nextDay(DateTime day) =>
      DateTime(day.year, day.month, day.day + 1);

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
