import 'package:flutter/material.dart';

import '../widgets/archived/archived_habits_list.dart';

class ArchivedHabitsPage extends StatelessWidget {
  const ArchivedHabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Archived Habits',
        ),
      ),
      body: const ArchivedHabitsList(),
    );
  }
}
