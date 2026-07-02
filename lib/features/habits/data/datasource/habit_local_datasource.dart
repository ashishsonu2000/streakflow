import '../../domain/models/habit.dart';

abstract class HabitLocalDataSource {
  Future<List<Habit>> getAll();

  Future<Habit?> getById(String id);

  Stream<List<Habit>> watchAll();

  Future<void> save(Habit habit);

  Future<void> delete(String id);

  Future<void> archive(String id);

  Future<void> restore(String id);
}
