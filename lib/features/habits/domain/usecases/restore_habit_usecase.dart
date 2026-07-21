import '../repositories/habit_repository.dart';

class RestoreHabitUseCase {
  RestoreHabitUseCase(this._repository);

  final HabitRepository _repository;

  Future<void> call(String habitId) {
    return _repository.restore(habitId);
  }
}
