import '../../../habits/domain/repositories/habit_repository.dart';

class ResetApplicationUseCase {
  const ResetApplicationUseCase(
      this._repository,
      );

  final HabitRepository _repository;

  Future<void> execute() async {
    await _repository.clearDatabase();
  }
}