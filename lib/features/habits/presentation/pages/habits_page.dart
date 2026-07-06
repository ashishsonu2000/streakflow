import 'package:flutter/material.dart';

import '../widgets/habit_filter_bar.dart';
import '../widgets/habit_search_bar.dart';
import '../widgets/habit_sort_button.dart';
import '../widgets/habits_header.dart';
import '../widgets/habits_list.dart';
import 'habit_form_page.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habits"),
        centerTitle: false,
        actions: const [
          HabitSortButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HabitFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            HabitsHeader(),
            HabitSearchBar(),
            HabitFilterBar(),
            Expanded(
              child: HabitsList(),
            ),
          ],
        ),
      ),
    );
  }
}
