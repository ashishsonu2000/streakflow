import 'package:flutter/material.dart';

import '../dashboard/domain/models/habit_summary.dart';
import '../dashboard/widgets/sections/section_title.dart';
import '../habits/habit_card.dart';

/// ===============================================================
///
/// Today's Habits Section
///
/// Responsibilities
/// • Section header
/// • Empty state
/// • Habit list
/// • Complete habit callback
/// • Habit tap callback
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "Today's Habits",
          actionText: habits.isEmpty ? null : "See All",
          onActionPressed: onSeeAll,
        ),
        const SizedBox(height: 16),
        if (habits.isEmpty)
          _buildEmptyState(context)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: habits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final habit = habits[index];

              return HabitCard(
                key: ValueKey(habit.id),
                habit: habit,
                onTap: () {
                  onHabitTap?.call(habit);
                },
                onCompleted: (_) {
                  onHabitCompleted?.call(habit);
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
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
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              "No habits for today",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the Add Habit button to create your first habit.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
