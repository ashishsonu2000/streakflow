import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_service.dart';
import '../../domain/models/habit.dart';
import '../entities/habit_entity.dart';
import '../mapper/habit_mapper.dart';
import 'habit_local_datasource.dart';

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final IsarService _isarService;
  final HabitMapper _mapper;

  HabitLocalDataSourceImpl(
    this._isarService,
    this._mapper,
  );

  Future<Isar> get _db => _isarService.database;

  @override
  Future<List<Habit>> getAll() async {
    final db = await _db;

    final entities = await db.habitEntitys.where().findAll();

    return entities.map(_mapper.toDomain).toList();
  }

  @override
  Future<Habit?> getById(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) {
      return null;
    }

    return _mapper.toDomain(entity);
  }

  @override
  Stream<List<Habit>> watchAll() async* {
    final db = await _db;

    yield* db.habitEntitys.where().watch(fireImmediately: true).map(
          (items) => items.map(_mapper.toDomain).toList(),
        );
  }

  @override
  Future<void> save(Habit habit) async {
    final db = await _db;

    final entity = _mapper.toEntity(habit);

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) return;

    await db.writeTxn(() async {
      await db.habitEntitys.delete(entity.id);
    });
  }

  @override
  Future<void> archive(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) return;

    entity.archived = true;

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });
  }

  @override
  Future<void> restore(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) return;

    entity.archived = false;

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });
  }
}
