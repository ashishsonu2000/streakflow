import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/app_logger.dart';
import '../../../core/utils/date_utils.dart';
import '../../calendar/presentation/providers/calendar_provider.dart';
import '../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../habits/domain/enums/completion_status.dart';
import '../../habits/domain/models/habit.dart';
import '../../habits/presentation/provider/filtered_habits_provider.dart';
import '../../habits/presentation/provider/habit_providers.dart';
import '../../notifications/domain/services/notification_service.dart';
import '../../notifications/presentation/providers/notification_service_provider.dart';
import '../../statistics/presentation/provider/statistics_provider.dart';
import '../data/screen_time_service.dart';
import '../domain/screen_time_auto_completer.dart';

final screenTimeServiceProvider = Provider<ScreenTimeService>(
  (ref) => const ScreenTimeService(),
);

/// Whether screen time can be used here (Android; iOS 16+).
final screenTimeAvailableProvider = FutureProvider<bool>(
  (ref) => ref.read(screenTimeServiceProvider).isAvailable(),
);

/// Android: "Usage access" is on. iPhone: Screen Time permission and
/// chosen apps. Invalidate after returning from the system settings or
/// the app picker.
final usageAccessProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.read(screenTimeServiceProvider).hasUsageAccess(),
);

/// Screen time so far today, or null when unknown.
final todayScreenTimeProvider = FutureProvider.autoDispose<int?>(
  (ref) => ref.read(screenTimeServiceProvider).minutesOn(DateTime.now()),
);

/// Android: opens "Usage access" (the state is re-read on resume).
/// iPhone: Screen Time permission and app picker, then starts the
/// monitors for the chosen apps.
Future<void> setUpScreenTime(WidgetRef ref) async {
  await ref.read(screenTimeServiceProvider).openUsageAccessSettings();
  ref.invalidate(usageAccessProvider);
  await ref.read(screenTimeSyncProvider).run('access changed');
}

/// Keeps "Digital detox" habits working on Android and iPhone:
///
/// • hands the limits to the background check (ScreenTimeWorker.kt /
///   the DeviceActivityMonitor extension), which notifies when today's
///   screen time reaches a limit;
/// • completes past days that stayed under the limit.
///
/// Activate by reading it once (MainShell); call [ScreenTimeSync.run]
/// again on resume.
final screenTimeSyncProvider = Provider<ScreenTimeSync>((ref) {
  final sync = ScreenTimeSync(ref);

  // Habit added, edited, archived or deleted.
  ref.listen<AsyncValue<List<Habit>>>(allActiveHabitsProvider, (_, next) {
    final habits = next.valueOrNull;
    if (habits != null) sync.syncLimits(habits);
  });

  // In-app "Habit Reminders" switch turned on or off.
  ref.listen<bool>(
    notificationProvider.select((state) => state.enabled),
    (previous, next) {
      if (previous != next) sync.run('reminders switch');
    },
  );

  Future.microtask(() => sync.run('startup'));

  return sync;
});

class ScreenTimeSync {
  ScreenTimeSync(this._ref);

  final Ref _ref;

  ScreenTimeService get _service => _ref.read(screenTimeServiceProvider);

  Future<void> run(String reason) async {
    if (!_service.isSupported) return;

    try {
      final habits =
          await _ref.read(habitRepositoryProvider).getAllForCalendar();

      await syncLimits(habits);

      if (!habits.any((habit) => habit.isScreenTimeLimit)) return;
      if (!await _service.hasUsageAccess()) return;

      final completed = await _autoCompleter().run(habits);

      if (completed > 0) {
        AppLogger.log(
          '[ScreenTime] Completed $completed day(s) under the limit ($reason)',
        );
        _refreshProviders();
      }
    } catch (error) {
      AppLogger.log('[ScreenTime] Sync failed ($reason): $error');
    }
  }

  Future<void> syncLimits(List<Habit> habits) async {
    if (!_service.isSupported) return;

    await _service.syncLimits(
      enabled: await NotificationService.remindersSwitchedOn(),
      limits: ScreenTimeAutoCompleter.alertsFor(habits),
    );
  }

  ScreenTimeAutoCompleter _autoCompleter() {
    final repository = _ref.read(habitRepositoryProvider);

    return ScreenTimeAutoCompleter(
      underLimit: _service.isIOS
          ? (habit, day) => _service.dayResult(habit.id, day)
          : ScreenTimeAutoCompleter.fromMinutes(_service.minutesOn),
      isCompletedOn: (habitId, day) async {
        final logs = await repository.getHabitLogsForHabit(habitId);
        return logs.any(
          (log) =>
              log.status == CompletionStatus.completed &&
              AppDateUtils.dateOnly(log.date) == day,
        );
      },
      complete: (habitId, day) =>
          _ref.read(completeHabitUseCaseProvider)(habitId, date: day),
    );
  }

  /// Same as HabitCommandNotifier after a completion.
  void _refreshProviders() {
    _ref
      ..invalidate(filteredHabitsProvider)
      ..invalidate(dashboardProvider)
      ..invalidate(calendarProvider)
      ..invalidate(statisticsProvider);
  }
}
