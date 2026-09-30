import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entitlements/entitlement_provider.dart';
import '../../domain/services/habit_limit_guard.dart';
import 'habit_repository_provider.dart';

/// Free plan active-habit limit, shared by every path that adds an
/// active habit (create, duplicate, onboarding, unarchive).
final habitLimitGuardProvider = Provider<HabitLimitGuard>((ref) {
  return HabitLimitGuard(
    countActiveHabits: () async {
      final habits = await ref.read(habitRepositoryProvider).getAll();
      return habits.where((habit) => !habit.archived).length;
    },
    access: () => ref.read(featureAccessProvider),
  );
});
