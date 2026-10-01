import '../../../../core/entitlements/feature_access.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../profile/domain/models/user_profile.dart';
import '../services/backup_codec.dart';

/// What a restore did.
class RestoreResult {
  const RestoreResult({
    required this.habits,
    required this.logs,
    required this.archivedForLimit,
    required this.reminderFailures,
  });

  final int habits;
  final int logs;

  /// Active habits archived because the Free plan allows fewer.
  final List<String> archivedForLimit;

  /// Habits whose reminders could not be scheduled.
  final int reminderFailures;
}

/// Replaces all habits and history with a backup's contents.
///
/// • Free plan: if the backup has more active habits than allowed, the
///   longest-running ones (earliest start date) stay active and the
///   rest are archived (nothing is deleted; Premium or archiving others
///   brings them back).
/// • Habits and logs are written in one transaction
///   (HabitRepository.replaceAllData): a failure leaves the existing
///   data and reminders untouched.
/// • Then old reminders are cancelled and the restored ones scheduled.
class RestoreBackupUseCase {
  const RestoreBackupUseCase({
    required HabitRepository repository,
    required FeatureAccess Function() access,
    required Future<UserProfile> Function() loadProfile,
    required Future<void> Function(UserProfile profile) saveProfile,
    required Future<void> Function() cancelAllReminders,
    required Future<void> Function(Habit habit) scheduleReminder,
    DateTime Function()? now,
  })  : _repository = repository,
        _access = access,
        _loadProfile = loadProfile,
        _saveProfile = saveProfile,
        _cancelAllReminders = cancelAllReminders,
        _scheduleReminder = scheduleReminder,
        _now = now;

  final HabitRepository _repository;
  final FeatureAccess Function() _access;
  final Future<UserProfile> Function() _loadProfile;
  final Future<void> Function(UserProfile profile) _saveProfile;
  final Future<void> Function() _cancelAllReminders;
  final Future<void> Function(Habit habit) _scheduleReminder;
  final DateTime Function()? _now;

  /// Habits that would be archived on the current plan (for the
  /// preview). Longest-running habits (earliest start date, then
  /// earliest creation) are kept active first.
  List<Habit> habitsOverLimit(BackupContents contents) {
    final limit = _access().activeHabitLimit;
    if (limit == null) {
      return const [];
    }

    final active = contents.habits.where((h) => !h.archived).toList()
      ..sort((a, b) {
        final byStart = a.startDate.compareTo(b.startDate);
        return byStart != 0 ? byStart : a.createdAt.compareTo(b.createdAt);
      });

    return active.length <= limit ? const [] : active.sublist(limit);
  }

  Future<RestoreResult> call(BackupContents contents) async {
    // -------------------------------------------------------
    // Plan limit
    // -------------------------------------------------------

    final overLimit = {for (final h in habitsOverLimit(contents)) h.id};
    final now = _now?.call() ?? DateTime.now();

    final habits = [
      for (final habit in contents.habits)
        overLimit.contains(habit.id)
            ? habit.copyWith(archived: true, updatedAt: now)
            : habit,
    ];

    // -------------------------------------------------------
    // Replace data (single transaction)
    // -------------------------------------------------------

    // Throws on failure, leaving data and reminders untouched.
    await _repository.replaceAllData(
      habits: habits,
      logs: contents.logs,
    );

    // The old reminders belong to habits that no longer exist.
    try {
      await _cancelAllReminders();
    } catch (error) {
      AppLogger.log('[Restore] Cancelling old reminders failed: $error');
    }

    // -------------------------------------------------------
    // Profile (name, goals, preferences; never onboarding)
    // -------------------------------------------------------

    final profile = contents.profile;
    if (profile != null) {
      try {
        final current = await _loadProfile();
        await _saveProfile(
          current.copyWith(
            name: profile.name.isEmpty ? current.name : profile.name,
            goals: profile.goals,
            notificationsEnabled: profile.notificationsEnabled,
            themeMode: profile.themeMode,
          ),
        );
      } catch (error) {
        AppLogger.log('[Restore] Restoring the profile failed: $error');
      }
    }

    // -------------------------------------------------------
    // Reminders
    // -------------------------------------------------------

    var reminderFailures = 0;
    for (final habit in habits) {
      if (habit.archived || !habit.reminderEnabled) {
        continue;
      }
      try {
        await _scheduleReminder(habit);
      } catch (error) {
        reminderFailures++;
        AppLogger.log(
          '[Restore] Reminder for ${habit.title} failed: $error',
        );
      }
    }

    AppLogger.log(
      '[Restore] ${habits.length} habit(s), ${contents.logs.length} log(s); '
      '${overLimit.length} archived for the plan limit.',
    );

    return RestoreResult(
      habits: habits.length,
      logs: contents.logs.length,
      archivedForLimit: [
        for (final habit in habits)
          if (overLimit.contains(habit.id)) habit.title,
      ],
      reminderFailures: reminderFailures,
    );
  }
}
