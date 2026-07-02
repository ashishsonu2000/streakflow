import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'schemas.dart';

class IsarService {
  Isar? _db;

  Future<Isar> get database async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    }

    final directory = await getApplicationDocumentsDirectory();

    _db = await Isar.open(
      databaseSchemas,
      directory: directory.path,
      inspector: true,
    );

    return _db!;
  }

  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
    }

    _db = null;
  }

  Future<void> clearDatabase() async {
    final db = await database;

    await db.writeTxn(() async {
      await db.clear();
    });
  }
}
