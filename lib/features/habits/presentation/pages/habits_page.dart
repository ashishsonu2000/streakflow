import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_card_provider.dart';

import '../widgets/filters/habit_search_bar.dart';
import '../widgets/habit_filter_bar.dart';
import '../widgets/list/habit_list.dart';

class HabitsPage extends ConsumerStatefulWidget {
  const HabitsPage({super.key});

  @override
  ConsumerState<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends ConsumerState<HabitsPage> {
  final _searchController = TextEditingController();

  String _query = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitCardProvider);

    final filteredHabits = habits.where((habit) {
      final query = _query.toLowerCase();

      return habit.title.toLowerCase().contains(query) ||
          habit.description.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Add Habit"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: HabitSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: HabitFilterBar(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: HabitList(
                habits: filteredHabits,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
