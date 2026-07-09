import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/habits_view_state.dart';
import '../../domain/models/habit_category.dart';

final habitsViewProvider =
    NotifierProvider<HabitsViewNotifier, HabitsViewState>(
  HabitsViewNotifier.new,
);

class HabitsViewNotifier extends Notifier<HabitsViewState> {
  @override
  HabitsViewState build() {
    return const HabitsViewState();
  }

  void setSearch(String value) {
    state = state.copyWith(
      search: value,
    );
  }

  void clearSearch() {
    state = state.copyWith(
      search: '',
    );
  }

  void setCategory(
    HabitCategory? category,
  ) {
    state = state.copyWith(
      category: category,
    );
  }

  void clearCategory() {
    state = state.copyWith(
      clearCategory: true,
    );
  }

  void setSort(
    HabitSort sort,
  ) {
    state = state.copyWith(
      sort: sort,
    );
  }
}
