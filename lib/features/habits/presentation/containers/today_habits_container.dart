import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/domain/habit_summary_mapper.dart';
import '../../../dashboard/domain/models/habit_card_model.dart';
import '../../../dashboard/presentation/actions/habit_card_actions.dart';
import '../../../habits/domain/models/habit_form_arguments.dart';
import '../../../habits/presentation/pages/habit_form_page.dart';
import '../../../habits/presentation/provider/filtered_habits_provider.dart';
import '../../../habits/presentation/provider/habit_providers.dart';

import '../sections/habits_list_section.dart';

class TodayHabitsContainer extends ConsumerWidget {
  const TodayHabitsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = HabitCardActions();
    final habitsAsync = ref.watch(filteredHabitsProvider);

    const mapper = HabitSummaryMapper();

    return habitsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      data: (habits) {
        final items = habits
            .map(
              (habit) => HabitCardModel(
                habit: habit,
                summary: mapper.toSummary(habit),
              ),
            )
            .toList();

        return HabitListSection(
          title: "Today's Habits",
          actionText: "See All",

          habits: items,

          //--------------------------------------------------
          // Complete
          //--------------------------------------------------

          onHabitCompleted: (item, completed) async {
            final notifier = ref.read(habitNotifierProvider.notifier);

            if (completed) {
              await notifier.completeHabit(item!.habit.id);
            } else {
              await notifier.uncompleteHabit(item.habit.id);
            }
          },

          //--------------------------------------------------
          // Tap
          //--------------------------------------------------

          onHabitTap: (item) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HabitFormPage(
                  arguments: HabitFormArguments(
                    habit: item.habit,
                  ),
                ),
              ),
            );
          },

          //--------------------------------------------------
          // Edit
          //--------------------------------------------------

          onEdit: (item) {
            actions.edit(context, ref, item.habit);
          },

          //--------------------------------------------------
          // Duplicate
          //--------------------------------------------------

          onDuplicate: (item) {
            actions.duplicate(context, ref, item.habit);
          },

          //--------------------------------------------------
          // Archive
          //--------------------------------------------------

          onArchive: (item) {
            actions.archive(context, ref, item.habit);
          },

          //--------------------------------------------------
          // Delete
          //--------------------------------------------------

          onDelete: (item) {
            actions.delete(context, ref, item.habit);
          },
        );
      },
    );
  }
}
