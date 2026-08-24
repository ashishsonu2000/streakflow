import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

import '../../data/services/backup_service.dart';

final backupServiceProvider = Provider(
      (_) => const BackupService(),
);

final exportBackupProvider =
FutureProvider.family<void, void>(
      (ref, _) async {
    final profileRepository = ref.read(
      profileRepositoryProvider,
    );

    final habitRepository = ref.read(
      habitRepositoryProvider,
    );

    final backupService = ref.read(
      backupServiceProvider,
    );

    final profile = await profileRepository.getProfile();

    final habits = await habitRepository.getAll();

    final logs = await habitRepository.getLogs();

    await backupService.export(
      profile: profile,
      habits: habits,
      logs: logs,
    );
  },
);