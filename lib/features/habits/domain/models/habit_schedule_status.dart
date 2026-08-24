import 'habit.dart';

enum HabitScheduleStatus {
  upcoming,
  active,
  expired,
}

extension HabitScheduleStatusX on HabitScheduleStatus {
  String get label {
    switch (this) {
      case HabitScheduleStatus.upcoming:
        return 'Upcoming';

      case HabitScheduleStatus.active:
        return 'Active';

      case HabitScheduleStatus.expired:
        return 'Expired';
    }
  }
}

extension HabitScheduleX on Habit {
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

    return HabitScheduleStatus.active;
  }

  bool get isScheduleActive =>
      scheduleStatus == HabitScheduleStatus.active;

  bool get isUpcoming =>
      scheduleStatus == HabitScheduleStatus.upcoming;

  bool get isExpired =>
      scheduleStatus == HabitScheduleStatus.expired;
}