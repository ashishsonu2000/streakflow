import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit.dart';
import '../state/habits_view_state.dart';
import 'habit_providers.dart';
import 'habits_view_provider.dart';

final filteredHabitsProvider = Provider<AsyncValue<List<Habit>>>((ref) {
  final habitsAsync = ref.watch(habitsProvider);
  final view = ref.watch(habitsViewProvider);

  return habitsAsync.whenData((habits) {
    List<Habit> filtered = [...habits];
    for (final h in filtered) {
      AppLogger.log(
        'UI Habit -> ${h.title} '
        'Current=${h.currentStreak} '
        'Best=${h.bestStreak}',
      );
    }
    // Search
    if (view.search.isNotEmpty) {
      final query = view.search.toLowerCase();

      filtered = filtered.where((habit) {
        return habit.title.toLowerCase().contains(query) ||
            habit.description.toLowerCase().contains(query);
      }).toList();
    }

    // Category
    if (view.category != null) {
      filtered =
          filtered.where((habit) => habit.category == view.category).toList();
    }

    // Sort
    switch (view.sort) {
      case HabitSort.newest:
        filtered.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );
        break;

      case HabitSort.oldest:
        filtered.sort(
          (a, b) => a.createdAt.compareTo(b.createdAt),
        );
        break;

      case HabitSort.alphabetical:
        filtered.sort(
          (a, b) => a.title.compareTo(b.title),
        );
        break;

      case HabitSort.highestStreak:
        filtered.sort(
          (a, b) => b.currentStreak.compareTo(a.currentStreak),
        );
        break;

      case HabitSort.highestXP:
        filtered.sort(
          (a, b) => b.xp.compareTo(a.xp),
        );
        break;
    }

    return filtered;
  });
});
