import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'schemas.dart';

class IsarService {
  IsarService({
    String? directory,
    String? databaseName,
    bool inspector = true,
  })  : _directory = directory,
        _databaseName = databaseName,
        _inspector = inspector;

  IsarService._()
      : _directory = null,
        _databaseName = null,
        _inspector = true;

  static final IsarService instance =
  IsarService._();

  final String? _directory;
  final String? _databaseName;
  final bool _inspector;

  Future<Isar>? _opening;

  Isar? _db;

  Future<Isar> get database {
    if (_db != null && _db!.isOpen) {
      return Future.value(_db!);
    }

    _opening ??= _openDatabase();

    return _opening!;
  }

  Future<Isar> _openDatabase() async {
    final directory =
        _directory ??
            (await getApplicationDocumentsDirectory()).path;

    final db = await Isar.open(
      databaseSchemas,
      directory: directory,
      name: _databaseName ?? 'streak_calculator',
      inspector: _inspector,
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