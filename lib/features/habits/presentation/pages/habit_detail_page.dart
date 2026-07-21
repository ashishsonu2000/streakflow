import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/ui/layouts/layouts.dart';

import '../../domain/models/habit.dart';

class HabitDetailPage extends ConsumerWidget {
  const HabitDetailPage({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //------------------------------------------------------
                // Header
                //------------------------------------------------------

                Text(
                  habit.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                if (habit.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    habit.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],

                const SizedBox(height: 32),

                //------------------------------------------------------
                // Placeholder
                //------------------------------------------------------

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Habit Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text('Current Streak: ${habit.currentStreak}'),
                        Text('Best Streak: ${habit.bestStreak}'),
                        Text('XP: ${habit.xp}'),
                        Text('Target Per Day: ${habit.targetPerDay}'),
                        Text('Completed Today: ${habit.completedToday}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                FilledButton.icon(
                  onPressed: () {
                    // TODO: Navigate to edit page
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Habit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}