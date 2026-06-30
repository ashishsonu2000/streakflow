import 'package:flutter/material.dart';

import '../dashboard/domain/models/habit_summary.dart';
import '../dashboard/widgets/sections/section_title.dart';
import '../habits/habit_card.dart';

/// ===============================================================
///
/// Today's Habits Section
///
/// Displays today's habits in a modern card layout.
///
/// Responsibilities:
/// • Section header
/// • Empty state
/// • Habit list
///
/// ===============================================================

class TodayHabits extends StatelessWidget {
  final List<HabitSummary> habits;

  final VoidCallback? onSeeAll;

  final ValueChanged<HabitSummary>? onHabitTap;

  final ValueChanged<HabitSummary>? onHabitCompleted;

  const TodayHabits({
    super.key,
    required this.habits,
    this.onSeeAll,
    this.onHabitTap,
    this.onHabitCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: "Today's Habits",
            actionText: "See All",
            onActionPressed: onSeeAll,
          ),
          const SizedBox(height: 16),
          _buildEmptyState(context),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "Today's Habits",
          actionText: "See All",
          onActionPressed: onSeeAll,
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: habits.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final habit = habits[index];

            return HabitCard(
              habit: habit,
              onTap: () {
                onHabitTap?.call(habit);
              },
              onCompleted: (value) {
                onHabitCompleted?.call(habit);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        child: Column(
          children: [
            Icon(
              Icons.task_alt_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              "No habits for today",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the + button to create your first habit.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
