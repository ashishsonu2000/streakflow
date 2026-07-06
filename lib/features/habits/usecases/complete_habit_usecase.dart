import '../domain/repositories/habit_repository.dart';

class CompleteHabitUseCase {
  final HabitRepository _repository;

  const CompleteHabitUseCase(this._repository);

  Future<void> call(
    String habitId, {
    int durationMinutes = 0,
    String notes = "",
  }) {
    return _repository.completeHabit(
      habitId,
      durationMinutes: durationMinutes,
      notes: notes,
    );
  }
}
