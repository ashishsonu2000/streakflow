import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entitlements/entitlement_provider.dart';
import '../../../habits/presentation/provider/habit_providers.dart';
import '../../../notifications/presentation/providers/notification_service_provider.dart';
import '../../../notifications/presentation/providers/notification_usecase_provider.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

import '../../data/services/backup_service.dart';
import '../../data/services/restore_service.dart';
import '../../domain/usecases/restore_backup_usecase.dart';

final backupServiceProvider = Provider(
      (_) => const BackupService(),
);

final restoreServiceProvider = Provider(
      (_) => const RestoreService(),
);

/// Exports every habit (archived included), all history and the
/// profile to a JSON backup and opens the share sheet.
final exportBackupProvider = Provider<Future<void> Function()>(
      (ref) {
    return () async {
      final profile =
      await ref.read(profileRepositoryProvider).getProfile();

      final habitRepository = ref.read(
        habitRepositoryProvider,
      );

      // Every habit, archived included. getAll() would only return
      // habits scheduled for today, silently leaving the rest out.
      final habits = await habitRepository.getAllIncludingArchived();

      final logs = await habitRepository.getLogs();

      await ref.read(backupServiceProvider).export(
        profile: profile,
        habits: habits,
        logs: logs,
      );
    };
  },
);

final restoreBackupUseCaseProvider = Provider<RestoreBackupUseCase>(
      (ref) {
    final profiles = ref.read(profileRepositoryProvider);

    return RestoreBackupUseCase(
      repository: ref.read(habitRepositoryProvider),
      access: () => ref.read(featureAccessProvider),
      loadProfile: profiles.getProfile,
      saveProfile: profiles.saveProfile,
      cancelAllReminders: () =>
          ref.read(notificationServiceProvider).cancelAll(),
      scheduleReminder: (habit) =>
          ref.read(scheduleHabitReminderUseCaseProvider)(habit),
    );
  },
);
