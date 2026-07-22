import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/ui/layouts/responsive_layout.dart';
import '../widgets/habits_list.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
      ),
      body: const SafeArea(
        child: ResponsiveLayout(
          child: HabitsList(),
        ),
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
