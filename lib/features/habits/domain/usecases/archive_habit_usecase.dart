import '../repositories/habit_repository.dart';

class ArchiveHabitUseCase {
  ArchiveHabitUseCase(this._repository);

  final HabitRepository _repository;

  Future<void> call(String habitId) {
    return _repository.archive(habitId);
  }
}
