import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HabitFilter {
  all,
  today,
  completed,
  pending,
  archived,
}

final habitFilterProvider =
    StateProvider<HabitFilter>((ref) => HabitFilter.all);
