import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/shared_preferences_provider.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/presentation/providers/habit_repository_provider.dart';
import 'notification_usecase_provider.dart';

/// Bump to reschedule every habit reminder once after an update that
/// changes how reminders are scheduled.
///
///   2: timezone fix (legacy zone names such as "Asia/Calcutta" no
///      longer fall back to UTC).
const reminderScheduleVersion = 2;

const _versionKey = 'reminder_schedule_version';

/// Once per [reminderScheduleVersion]: reschedules every habit with a
/// reminder (scheduling cancels the habit's old reminder first), so
/// reminders scheduled by an older version are corrected without the
/// user editing each habit.
///
/// Activate by reading it once (MainShell).
final reminderEntitlementSyncProvider = Provider<void>((ref) {
  Future.microtask(() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final stored = prefs?.getInt(_versionKey) ?? 0;

    if (stored >= reminderScheduleVersion) {
      return;
    }

    try {
      // Every active habit, not only those scheduled today.
      final habits =
          await ref.read(habitRepositoryProvider).getAllForCalendar();
      final affected = habits.where(hasReminder).toList();
      final schedule = ref.read(scheduleHabitReminderUseCaseProvider);

      for (final habit in affected) {
        await schedule(habit);
      }

      AppLogger.log(
        '[Reminders] Rescheduled ${affected.length} habit(s) '
        '(one-time reschedule v$stored -> v$reminderScheduleVersion)',
      );

      await prefs?.setInt(_versionKey, reminderScheduleVersion);
    } catch (error) {
      // Retried on the next launch.
      AppLogger.log('[Reminders] One-time reschedule failed: $error');
    }
  });
});

/// Habits with a reminder at all.
bool hasReminder(Habit habit) =>
    !habit.archived && habit.reminderEnabled;
