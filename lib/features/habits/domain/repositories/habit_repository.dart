import '../models/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> getAll();

  Stream<List<Habit>> watchAll();

  Future<Habit?> getById(String id);

  Future<void> save(Habit habit);

  Future<void> delete(String id);

  Future<void> archive(String id);

  Future<void> restore(String id);
}
