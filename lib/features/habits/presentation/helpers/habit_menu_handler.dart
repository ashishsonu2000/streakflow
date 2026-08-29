import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../shared/widgets/dialogs/archive_habit_dialog.dart';
import '../../../../shared/widgets/dialogs/delete_habit_dialog.dart';

import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_form_arguments.dart';
import '../../../habits/presentation/pages/habit_form_page.dart';
import '../../../habits/presentation/provider/habit_providers.dart';
import '../../../habits/presentation/services/deleted_habit_cache.dart';
import '../../../habits/presentation/widgets/duplicate_habit_dialog.dart';

import '../pages/habit_history_page.dart';
import '../widgets/actions/habit_popup_menu.dart';

class HabitMenuHandler {
  HabitMenuHandler();

  // =========================================================
  // HANDLE MENU ACTION
  // =========================================================

  static Future<void> handle({
    required BuildContext context,
    required WidgetRef ref,
    required Habit habit,
    required HabitMenuAction action,
  }) async {
    final handler = HabitMenuHandler();

    switch (action) {
    // -------------------------------------------------------
    // EDIT
    // -------------------------------------------------------

      case HabitMenuAction.edit:
        await handler.edit(
          context,
          ref,
          habit,
        );
        break;

    // -------------------------------------------------------
    // DUPLICATE
    // -------------------------------------------------------

      case HabitMenuAction.duplicate:
        await handler.duplicate(
          context,
          ref,
          habit,
        );
        break;

    // -------------------------------------------------------
    // ARCHIVE
    // -------------------------------------------------------

      case HabitMenuAction.archive:
        await handler.archive(
          context,
          ref,
          habit,
        );
        break;

    // -------------------------------------------------------
    // DELETE
    // -------------------------------------------------------

      case HabitMenuAction.delete:
        await handler.delete(
          context,
          ref,
          habit,
        );
        break;

    // -------------------------------------------------------
    // HISTORY
    // -------------------------------------------------------

      case HabitMenuAction.history:
        await handler.history(
          context,
          ref,
          habit,
        );
        break;
    }
  }

  // =========================================================
  // EDIT
  // =========================================================

  Future<void> edit(
      BuildContext context,
      WidgetRef ref,
      Habit habit,
      ) async {
    if (!context.mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HabitFormPage(
          arguments: HabitFormArguments(
            habit: habit,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // DUPLICATE
  // =========================================================

  Future<void> duplicate(
      BuildContext context,
      WidgetRef ref,
      Habit habit,
      ) async {
    final confirmed =
    await DuplicateHabitDialog.show(
      context,
      habit.title,
    );

    if (!confirmed || !context.mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HabitFormPage(
          arguments: HabitFormArguments(
            habit: habit,
            duplicate: true,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // ARCHIVE
  // =========================================================

  Future<void> archive(
      BuildContext context,
      WidgetRef ref,
      Habit habit,
      ) async {
    final confirmed =
    await ArchiveHabitDialog.show(
      context,
      habit.title,
    );

    if (!confirmed) {
      return;
    }

    await ref
        .read(habitRepositoryProvider)
        .archive(habit.id);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${habit.title}" archived',
        ),
      ),
    );
  }

  // =========================================================
  // DELETE
  // =========================================================

  Future<void> delete(
      BuildContext context,
      WidgetRef ref,
      Habit habit,
      ) async {
    final confirmed =
    await DeleteHabitDialog.show(
      context,
      habit.title,
    );

    if (!confirmed) {
      return;
    }

    DeletedHabitCache.save(habit);

    await ref
        .read(habitRepositoryProvider)
        .delete(habit.id);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    final controller =
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration:
        const Duration(seconds: 5),
        content: Text(
          '"${habit.title}" deleted',
        ),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            final deleted =
            DeletedHabitCache.take();

            if (deleted == null) {
              return;
            }

            await ref
                .read(habitRepositoryProvider)
                .save(deleted);
          },
        ),
      ),
    );

    controller.closed.then((_) {
      if (DeletedHabitCache.hasHabit) {
        DeletedHabitCache.clear();
      }
    });
  }

  // =========================================================
  // HISTORY
  // =========================================================

  Future<void> history(
      BuildContext context,
      WidgetRef ref,
      Habit habit,
      ) async {
    if (!context.mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HabitHistoryPage(
          habitId: habit.id,
          habitTitle: habit.title,
        ),
      ),
    );
  }
}