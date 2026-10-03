import '../../../../core/entitlements/feature_access.dart';

/// Thrown when adding another ACTIVE habit would exceed the Free plan
/// limit. The UI turns this into an upgrade prompt.
class HabitLimitReachedException implements Exception {
  const HabitLimitReachedException(this.limit);

  final int limit;

  String get message =>
      'The Free plan includes up to $limit active habits. '
      'Upgrade to StreakFlow Premium for unlimited habits, or archive '
      'a habit to make room.';

  @override
  String toString() => 'HabitLimitReachedException(limit: $limit)';
}

/// Enforces the Free plan active-habit limit for every path that adds
/// an active habit: create, duplicate, onboarding suggestions and
/// unarchive. Editing, completing, archiving and deleting are never
/// limited, and habits already above the limit are never locked.
class HabitLimitGuard {
  const HabitLimitGuard({
    required Future<int> Function() countActiveHabits,
    required FeatureAccess Function() access,
  })  : _countActiveHabits = countActiveHabits,
        _access = access;

  final Future<int> Function() _countActiveHabits;
  final FeatureAccess Function() _access;

  Future<bool> canAddActiveHabit() async {
    final access = _access();

    if (access.isPremium) {
      return true;
    }

    return access.canAddActiveHabit(await _countActiveHabits());
  }

  /// Throws [HabitLimitReachedException] when the limit is reached.
  Future<void> ensureCanAddActiveHabit() async {
    if (!await canAddActiveHabit()) {
      throw HabitLimitReachedException(_access().freeHabitLimit);
    }
  }
}
