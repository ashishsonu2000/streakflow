import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/dialogs/archive_habit_dialog.dart';
import '../../../../shared/widgets/dialogs/delete_habit_dialog.dart';

import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_form_arguments.dart';

import '../../../habits/presentation/pages/habit_form_page.dart';
import '../../../habits/presentation/provider/filtered_habits_provider.dart';
import '../../../habits/presentation/provider/habit_providers.dart';
import '../../../habits/presentation/provider/habits_view_provider.dart';
import '../../../habits/presentation/services/deleted_habit_cache.dart';
import '../../../habits/presentation/widgets/duplicate_habit_dialog.dart';
import '../../../habits/presentation/state/habits_view_state.dart';

import '../../domain/habit_summary_mapper.dart';
import '../../domain/models/habit_card_model.dart';

import 'today_habits.dart';

class TodayHabitsContainer extends ConsumerWidget {
  const TodayHabitsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(filteredHabitsProvider);

    const mapper = HabitSummaryMapper();

    return habitsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Text(error.toString()),
      ),
      data: (habits) {
        final view = ref.watch(habitsViewProvider);

        List<Habit> filtered = [...habits];

//
// Search
//
        if (view.search.isNotEmpty) {
          final query = view.search.toLowerCase();

          filtered = filtered.where((habit) {
            return habit.title.toLowerCase().contains(query) ||
                habit.description.toLowerCase().contains(query);
          }).toList();
        }

//
// Category
//
        if (view.category != null) {
          filtered = filtered.where((habit) {
            return habit.category == view.category;
          }).toList();
        }

//
// Sort
//
        switch (view.sort) {
          case HabitSort.newest:
            filtered.sort(
              (a, b) => b.createdAt.compareTo(a.createdAt),
            );
            break;

          case HabitSort.oldest:
            filtered.sort(
              (a, b) => a.createdAt.compareTo(b.createdAt),
            );
            break;

          case HabitSort.alphabetical:
            filtered.sort(
              (a, b) => a.title.compareTo(b.title),
            );
            break;

          case HabitSort.highestStreak:
            filtered.sort(
              (a, b) => b.currentStreak.compareTo(a.currentStreak),
            );
            break;

          case HabitSort.highestXP:
            filtered.sort(
              (a, b) => b.xp.compareTo(a.xp),
            );
            break;
        }

        return TodayHabits(
          habits: filtered
              .map(
                (habit) => HabitCardModel(
                  habit: habit,
                  summary: mapper.toSummary(habit),
                ),
              )
              .toList(),

          //--------------------------------------------------
          // Complete Habit
          //--------------------------------------------------

          onHabitCompleted: (item, completed) async {
            final notifier = ref.read(habitNotifierProvider.notifier);

            if (completed) {
              await notifier.completeHabit(item.habit.id);
            } else {
              await notifier.uncompleteHabit(item.habit.id);
            }
          },

          //--------------------------------------------------
          // Edit
          //--------------------------------------------------

          onEdit: (item) {
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
          // Duplicate
          //--------------------------------------------------

          onDuplicate: (item) async {
            final confirmed = await DuplicateHabitDialog.show(
              context,
              item.habit.title,
            );

            if (!confirmed || !context.mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HabitFormPage(
                  arguments: HabitFormArguments(
                    habit: item.habit,
                    duplicate: true,
                  ),
                ),
              ),
            );
          },

          //--------------------------------------------------
          // Archive
          //--------------------------------------------------

          onArchive: (item) async {
            final confirmed = await ArchiveHabitDialog.show(
              context,
              item.habit.title,
            );

            if (!confirmed) return;

            await ref.read(habitRepositoryProvider).archive(item.habit.id);

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '"${item.habit.title}" archived',
                ),
              ),
            );
          },

          //--------------------------------------------------
          // Delete
          //--------------------------------------------------

          onDelete: (item) async {
            final confirmed = await DeleteHabitDialog.show(
              context,
              item.habit.title,
            );

            if (!confirmed) return;

            //--------------------------------------------------
            // Save deleted habit
            //--------------------------------------------------

            DeletedHabitCache.save(item.habit);

            //--------------------------------------------------
            // Delete
            //--------------------------------------------------

            await ref.read(habitRepositoryProvider).delete(item.habit.id);

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            final controller = ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 5),
                content: Text(
                  '"${item.habit.title}" deleted',
                ),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () async {
                    final deleted = DeletedHabitCache.take();

                    if (deleted == null) return;

                    await ref.read(habitRepositoryProvider).save(deleted);
                  },
                ),
              ),
            );

// Cleanup after SnackBar disappears

            // Cleanup after SnackBar disappears
            controller.closed.then((_) {
              if (DeletedHabitCache.hasHabit) {
                DeletedHabitCache.clear();
              }
            });
          },
        );
      },
    );
  }
}
