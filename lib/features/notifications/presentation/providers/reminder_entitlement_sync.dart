import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entitlements/entitlement_provider.dart';
import '../../../../core/storage/shared_preferences_provider.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/presentation/providers/habit_repository_provider.dart';
import 'notification_usecase_provider.dart';

/// Bump to reschedule every habit reminder once after an update that
/// changes how reminders are scheduled.
///
///   2: timezone fix (legacy zone names such as "Asia/Calcutta" no
///      longer fall back to UTC) + payload-tagged reminders.
const reminderScheduleVersion = 2;

const _versionKey = 'reminder_schedule_version';

/// Keeps scheduled reminders in line with the app and the plan.
///
/// • Once per [reminderScheduleVersion]: reschedules every habit with a
///   reminder (scheduling cancels the habit's old reminders first), so
///   reminders scheduled by an older version are corrected.
/// • At startup and whenever the reminders-per-habit limit changes
///   (Premium purchased, restored or expired): reschedules habits with
///   extra reminder times, the only ones a plan change affects.
///
/// Activate by reading it once (MainShell).
final reminderEntitlementSyncProvider = Provider<void>((ref) {
  Future<void> sync(String reason, bool Function(Habit) affects) async {
    try {
      // Every active habit, not only those scheduled today.
      final habits =
          await ref.read(habitRepositoryProvider).getAllForCalendar();
      final affected = habits.where(affects).toList();

      final schedule = ref.read(scheduleHabitReminderUseCaseProvider);

      for (final habit in affected) {
        await schedule(habit);
      }

      if (affected.isNotEmpty) {
        AppLogger.log(
          '[Reminders] Rescheduled ${affected.length} habit(s) ($reason)',
        );
      }
    } catch (error) {
      AppLogger.log('[Reminders] Sync failed ($reason): $error');
    }
  }

  ref.listen<int>(
    featureAccessProvider.select((access) => access.remindersPerHabit),
    (previous, next) {
      if (previous != next) {
        sync(
          'plan changed: $previous -> $next reminders per habit',
          needsSync,
        );
      }
    },
  );

  Future.microtask(() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final stored = prefs?.getInt(_versionKey) ?? 0;

    if (stored < reminderScheduleVersion) {
      await sync(
        'one-time reschedule v$stored -> v$reminderScheduleVersion',
        hasReminder,
      );
      await prefs?.setInt(_versionKey, reminderScheduleVersion);
    } else {
      await sync('startup', needsSync);
    }
  });
});

/// Habits with a reminder at all.
bool hasReminder(Habit habit) =>
    !habit.archived && habit.reminderEnabled;

/// Whether a plan change can affect this habit's scheduled reminders.
bool needsSync(Habit habit) =>
    hasReminder(habit) && habit.additionalReminderMinutes.isNotEmpty;
