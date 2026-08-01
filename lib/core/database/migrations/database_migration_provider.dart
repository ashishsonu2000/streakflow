import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/habits/domain/services/habit_statistics_rebuilder.dart';
import 'database_migration_service.dart';

final databaseMigrationServiceProvider =
    Provider<DatabaseMigrationService>((ref) {
  return DatabaseMigrationService(
    const HabitStatisticsRebuilder(),
  );
});
