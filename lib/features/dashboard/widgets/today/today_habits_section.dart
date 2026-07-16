import 'package:flutter/material.dart';

import '../../domain/models/today_habit_view_model.dart';
import 'today_habit_card.dart';

class TodayHabitsSection extends StatelessWidget {
  const TodayHabitsSection({
    super.key,
    required this.habits,
    this.onHabitTap,
    this.onHabitComplete,
    this.onViewAll,
  });

  final List<TodayHabitViewModel> habits;

  final void Function(TodayHabitViewModel habit)? onHabitTap;

  final void Function(TodayHabitViewModel habit)? onHabitComplete;

  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------------------------------------
            // Header
            //----------------------------------------------------------

            Row(
              children: [
                Expanded(
                  child: Text(
                    "Today's Habits",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: const Text("View All"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //----------------------------------------------------------
            // Empty State
            //----------------------------------------------------------

            if (habits.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 56,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No habits scheduled for today",
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Create a habit to start building your streak.",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )

            //----------------------------------------------------------
            // Habit List
            //----------------------------------------------------------

            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: habits.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final habit = habits[index];

                  return TodayHabitCard(
                    habit: habit,
                    onTap: () => onHabitTap?.call(habit),
                    onComplete: () => onHabitComplete?.call(habit),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
