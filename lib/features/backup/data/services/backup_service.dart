import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_log.dart';
import '../../../profile/domain/models/user_profile.dart';

import '../../domain/services/backup_codec.dart';

class BackupService {
  const BackupService();

  Future<void> export({
    required UserProfile profile,
    required List<Habit> habits,
    required List<HabitLog> logs,
  }) async {
    final backup = BackupCodec.encode(
      profile: profile,
      habits: habits,
      logs: logs,
      exportedAt: DateTime.now(),
    );

    final directory =
    await getTemporaryDirectory();

    final file = File(
      '${directory.path}/streak_backup.json',
    );

    await file.writeAsString(
      const JsonEncoder.withIndent(
        '  ',
      ).convert(
        backup,
      ),
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(
            file.path,
          ),
        ],
      ),
    );
  }
}
