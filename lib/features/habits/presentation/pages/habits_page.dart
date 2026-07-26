import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/habit_filter_bar.dart';
import '../widgets/habit_sort_button.dart';
import '../widgets/habits_list.dart';
import '../widgets/search/habit_search_bar.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
      ),
      body: const Column(
        children: [
          HabitSearchBar(),
          HabitFilterBar(),
          HabitSortButton(),
          Expanded(
            child: HabitsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed('habit-form');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Habit'),
      ),
    );
  }
}
