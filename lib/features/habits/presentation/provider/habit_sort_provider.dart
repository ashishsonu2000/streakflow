import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HabitSort {
  name,
  createdDate,
  currentStreak,
  bestStreak,
  xp,
}

final habitSortProvider = StateProvider<HabitSort>((ref) => HabitSort.name);
