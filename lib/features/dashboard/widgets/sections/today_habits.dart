import 'package:flutter/material.dart';

import '../../../habits/habit_card.dart';
import '../../domain/models/habit_summary.dart';

import 'section_title.dart';

class TodayHabits extends StatelessWidget {
  final List<HabitSummary> habits;

  final VoidCallback? onSeeAll;

  final ValueChanged<HabitSummary>? onHabitTap;

  final void Function(HabitSummary habit, bool completed)? onHabitCompleted;

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
              onTap: () => onHabitTap?.call(habit),
              onCompleted: (value) {
                onHabitCompleted?.call(habit, value);
              },
            );
          },
        ),
      ],
    );
  }
}
