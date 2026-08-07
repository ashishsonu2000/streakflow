import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class GetHabitsUseCase {
  const GetHabitsUseCase(
    this._repository,
  );

  final HabitRepository _repository;

  Future<List<Habit>> call() {
    return _repository.getAll();
  }
}
