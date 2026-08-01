import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'schemas.dart';

class IsarService {
  IsarService._();

  static final IsarService instance = IsarService._();

  Future<Isar>? _opening;
  Isar? _db;

  Future<Isar> get database {
    if (_db != null && _db!.isOpen) {
      return Future.value(_db);
    }

    _opening ??= _openDatabase();
    return _opening!;
  }

  Future<Isar> _openDatabase() async {
    final directory = await getApplicationDocumentsDirectory();

    final db = await Isar.open(
      databaseSchemas,
      directory: directory.path,
      inspector: true,
    );

    _db = db;
    _opening = null;

    return db;
  }

  Future<void> close() async {
    if (_db?.isOpen ?? false) {
      await _db!.close();
    }
    _db = null;
    _opening = null;
  }
}
