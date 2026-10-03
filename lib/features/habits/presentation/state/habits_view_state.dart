import '../../domain/models/habit_category.dart';

enum HabitSort {
  newest,
  oldest,
  alphabetical,
  highestStreak,
  highestXP,
}

class HabitsViewState {
  const HabitsViewState({
    this.search = '',
    this.category,
    this.sort = HabitSort.newest,
  });

  final String search;

  final HabitCategory? category;

  final HabitSort sort;

  HabitsViewState copyWith({
    String? search,
    HabitCategory? category,
    bool clearCategory = false,
    HabitSort? sort,
  }) {
    return HabitsViewState(
      search: search ?? this.search,
      category: clearCategory ? null : category ?? this.category,
      sort: sort ?? this.sort,
    );
  }
}
