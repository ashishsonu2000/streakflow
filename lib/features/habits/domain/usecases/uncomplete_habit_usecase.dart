import '../repositories/habit_repository.dart';

class UncompleteHabitUseCase {
  UncompleteHabitUseCase(this._repository);

  final HabitRepository _repository;

  Future<void> call(String habitId) {
    return _repository.uncompleteHabit(habitId);
  }
}
