import '../../data/datasource/habit_local_datasource.dart';
import '../../domain/models/habit.dart';
import '../../domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource _localDataSource;

  HabitRepositoryImpl(this._localDataSource);

  @override
  Future<List<Habit>> getAll() {
    return _localDataSource.getAll();
  }

  @override
  Stream<List<Habit>> watchAll() {
    return _localDataSource.watchAll();
  }

  @override
  Future<Habit?> getById(String id) {
    return _localDataSource.getById(id);
  }

  @override
  Future<void> save(Habit habit) {
    return _localDataSource.save(habit);
  }

  @override
  Future<void> delete(String id) {
    return _localDataSource.delete(id);
  }

  @override
  Future<void> archive(String id) {
    return _localDataSource.archive(id);
  }

  @override
  Future<void> restore(String id) {
    return _localDataSource.restore(id);
  }
}
