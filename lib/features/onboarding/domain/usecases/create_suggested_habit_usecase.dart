import 'package:uuid/uuid.dart';

import '../../../habits/domain/models/difficulty.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../habits/domain/services/habit_limit_guard.dart';

import '../models/suggested_habit.dart';

class CreateSuggestedHabitUseCase {
  const CreateSuggestedHabitUseCase(
      this._repository, {
      HabitLimitGuard? limitGuard,
      DateTime Function()? now,
      }) : _limitGuard = limitGuard,
           _now = now;

  final HabitRepository _repository;

  /// Free plan active-habit limit. Throws HabitLimitReachedException.
  final HabitLimitGuard? _limitGuard;

  final DateTime Function()? _now;

  /// Creates one suggested habit, starting today.
  Future<void> execute(
      SuggestedHabit suggestion,
      ) async {
    await _limitGuard?.ensureCanAddActiveHabit();

    await _repository.save(
      _toHabit(suggestion),
    );
  }

  /// Creates the picked suggestions (end of onboarding) and returns how
  /// many were created. Skips any that match an existing active habit's
  /// title (e.g. after Reset Onboarding) and stops quietly at the Free
  /// plan limit instead of failing the whole onboarding.
  Future<int> executeAll(
      List<SuggestedHabit> suggestions,
      ) async {
    final existing = (await _repository.getAllForCalendar())
        .map((habit) => habit.title.trim().toLowerCase())
        .toSet();

    var created = 0;

    for (final suggestion in suggestions) {
      if (!existing.add(suggestion.title.trim().toLowerCase())) {
        continue;
      }

      try {
        await execute(suggestion);
        created++;
      } on HabitLimitReachedException {
        break;
      }
    }

    return created;
  }

  Habit _toHabit(SuggestedHabit suggestion) {
    final now = _now?.call() ?? DateTime.now();

    final startDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    return Habit(
      id: const Uuid().v4(),

      title: suggestion.title,
      description: suggestion.description,

      category: suggestion.category,

      iconCodePoint: suggestion.icon.codePoint,
      colorValue: suggestion.colorValue,

      // =====================================================
      // Schedule
      // =====================================================

      frequency: suggestion.frequency,
      weeklyDays: List<int>.from(suggestion.weeklyDays),

      startDate: startDate,
      endDate: null,

      // =====================================================
      // Defaults
      // =====================================================

      createdAt: now,
      updatedAt: now,

      difficulty: Difficulty.easy,
      xpReward: 5,
      targetPerDay: 1,
      estimatedDurationMinutes: suggestion.durationMinutes,

      // Off by default; users turn reminders on per habit.
      reminderEnabled: false,

      currentStreak: 0,
      bestStreak: 0,
      totalCompleted: 0,
      xp: 0,

      archived: false,

      lastCompletedDate: null,
      completedToday: false,
    );
  }
}
