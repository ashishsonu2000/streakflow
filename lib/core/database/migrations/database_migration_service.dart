import 'package:isar_community/isar.dart';

import '../../../features/habits/domain/services/habit_statistics_rebuilder.dart';
import '../entities/database_metadata.dart';

class DatabaseMigrationService {
  DatabaseMigrationService(
    this._rebuilder,
  );

  final HabitStatisticsRebuilder _rebuilder;

  static const currentSchemaVersion = 2;

  Future<void> migrate(Isar db) async {
    var metadata = await db.databaseMetadatas.get(1);

    metadata ??= DatabaseMetadata();

    if (metadata.schemaVersion < 2) {
      await _rebuilder.rebuild(db);

      await db.writeTxn(() async {
        metadata!.schemaVersion = currentSchemaVersion;
        await db.databaseMetadatas.put(metadata);
      });
    }
  }
}
