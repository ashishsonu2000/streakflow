import '../../../core/utils/date_utils.dart';
import '../../habits/domain/models/habit.dart';
import '../../habits/domain/services/habit_schedule_service.dart';
import '../data/screen_time_service.dart';

/// Completes past days of "Digital detox" habits on which screen time
/// stayed under the limit.
///
/// Today is never completed here: it is only known once the day is
/// over. Runs at startup and on resume, looking back [lookbackDays]
/// days (Android keeps detailed usage events for a few days only).
/// Days whose result is unknown are skipped, not failed or completed.
class ScreenTimeAutoCompleter {
  ScreenTimeAutoCompleter({
    required this.underLimit,
    required this.isCompletedOn,
    required this.complete,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const lookbackDays = 3;

  static const _schedule = HabitScheduleService();

  /// Whether [habit] stayed under its limit on [day]; null = unknown.
  final Future<bool?> Function(Habit habit, DateTime day) underLimit;
  final Future<bool> Function(String habitId, DateTime day) isCompletedOn;
  final Future<void> Function(String habitId, DateTime day) complete;
  final DateTime Function() _clock;

  /// Returns how many habit days were completed.
  Future<int> run(List<Habit> habits) async {
    final today = AppDateUtils.dateOnly(_clock());
    var completed = 0;

    for (final habit in habits) {
      if (habit.screenTimeLimitMinutes == null || habit.archived) continue;

      for (var back = 1; back <= lookbackDays; back++) {
        final day = DateTime(today.year, today.month, today.day - back);

        if (!_isActiveOn(habit, day)) continue;
        if (await isCompletedOn(habit.id, day)) continue;

        if (await underLimit(habit, day) == true) {
          await complete(habit.id, day);
          completed++;
        }
      }
    }

    return completed;
  }

  /// Android: compares each day's usage minutes with the limit, reading
  /// every day once for all habits.
  static Future<bool?> Function(Habit, DateTime) fromMinutes(
    Future<int?> Function(DateTime day) minutesOn,
  ) {
    final cache = <DateTime, Future<int?>>{};

    return (habit, day) async {
      final minutes = await cache.putIfAbsent(day, () => minutesOn(day));
      final limit = habit.screenTimeLimitMinutes;
      if (minutes == null || limit == null) return null;
      return minutes < limit;
    };
  }

  static bool _isActiveOn(Habit habit, DateTime day) {
    if (day.isBefore(AppDateUtils.dateOnly(habit.startDate))) return false;

    final end = habit.endDate;
    if (end != null && day.isAfter(AppDateUtils.dateOnly(end))) return false;

    return _schedule.isScheduledForDate(habit, day);
  }

  /// Limits for the background check: each active limit habit with the
  /// next [days] days it is scheduled on (re-sent at every app start,
  /// so alerts stop if the app isn't opened for that long).
  static List<ScreenTimeLimitAlert> alertsFor(
    List<Habit> habits, {
    DateTime? now,
    int days = 14,
  }) {
    final today = AppDateUtils.dateOnly(now ?? DateTime.now());

    return [
      for (final habit in habits)
        if (habit.screenTimeLimitMinutes != null && !habit.archived)
          ScreenTimeLimitAlert(
            habitId: habit.id,
            title: habit.title,
            limitMinutes: habit.screenTimeLimitMinutes!,
            days: [
              for (var i = 0; i < days; i++)
                if (_isActiveOn(
                  habit,
                  DateTime(today.year, today.month, today.day + i),
                ))
                  ScreenTimeService.ymd(
                    DateTime(today.year, today.month, today.day + i),
                  ),
            ],
          ),
    ].where((alert) => alert.days.isNotEmpty).toList();
  }
}
