import '../repositories/habit_repository.dart';
import '../services/habit_limit_guard.dart';

/// Unarchives a habit, making it active again.
class RestoreHabitUseCase {
  RestoreHabitUseCase(
    this._repository, {
    HabitLimitGuard? limitGuard,
  }) : _limitGuard = limitGuard;

  final HabitRepository _repository;

  /// Free plan active-habit limit. Throws HabitLimitReachedException.
  final HabitLimitGuard? _limitGuard;

  Future<void> call(String habitId) async {
    await _limitGuard?.ensureCanAddActiveHabit();

    return _repository.restore(habitId);
  }
}
