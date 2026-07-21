import '../repositories/habit_repository.dart';

class DeleteHabitUseCase {
  DeleteHabitUseCase(this._repository);

  final HabitRepository _repository;

  Future<void> call(String habitId) {
    return _repository.delete(habitId);
  }
}
