import '../repositories/habit_repository.dart';

class CompleteHabitUseCase {
  CompleteHabitUseCase(this._repository);

  final HabitRepository _repository;

  Future<void> call(
    String habitId, {
    int durationMinutes = 0,
    String notes = '',
  }) {
    return _repository.completeHabit(
      habitId,
      durationMinutes: durationMinutes,
      notes: notes,
    );
  }
}
