import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/backup_service.dart';

final backupServiceProvider =
Provider<BackupService>(
      (_) => const BackupService(),
);