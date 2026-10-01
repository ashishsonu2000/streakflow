import '../services/habit_schedule_service.dart';
import 'habit.dart';

enum HabitScheduleStatus {
  upcoming,
  active,

  /// Within its date range, but not due today (e.g. a weekly habit on
  /// one of its off days). It can't be completed today.
  notToday,

  expired,
}

extension HabitScheduleStatusX on HabitScheduleStatus {
  String get label {
    switch (this) {
      case HabitScheduleStatus.upcoming:
        return 'Upcoming';

      case HabitScheduleStatus.active:
        return 'Active';

      case HabitScheduleStatus.notToday:
        return 'Not due today';

      case HabitScheduleStatus.expired:
        return 'Expired';
    }
  }
}

extension HabitScheduleX on Habit {
  static const _schedule = HabitScheduleService();

  /// How far ahead [nextDueDate] looks. Monthly habits on the 31st can
  /// be two months away.
  static const _searchDays = 400;

  HabitScheduleStatus get scheduleStatus {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final start = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    if (today.isBefore(start)) {
      return HabitScheduleStatus.upcoming;
    }

    if (endDate != null) {
      final end = DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
      );

      if (today.isAfter(end)) {
        return HabitScheduleStatus.expired;
      }
    }

    if (!_schedule.isScheduledIgnoringArchived(this, today)) {
      return HabitScheduleStatus.notToday;
    }

    return HabitScheduleStatus.active;
  }

  /// The next day (after today) this habit is due, or null if there is
  /// none (it ends first).
  DateTime? get nextDueDate {
    final now = DateTime.now();
    var day = DateTime(now.year, now.month, now.day + 1);

    for (var i = 0; i < _searchDays; i++) {
      if (_schedule.isScheduledIgnoringArchived(this, day)) {
        return day;
      }
      day = DateTime(day.year, day.month, day.day + 1);
    }

    return null;
  }

  bool get isScheduleActive =>
      scheduleStatus == HabitScheduleStatus.active;

  bool get isUpcoming =>
      scheduleStatus == HabitScheduleStatus.upcoming;

  bool get isExpired =>
      scheduleStatus == HabitScheduleStatus.expired;
}
