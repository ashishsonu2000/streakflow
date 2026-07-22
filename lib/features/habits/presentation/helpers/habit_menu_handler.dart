import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/dialogs/confirmation_dialog.dart';

import '../../../../core/ui/snackbar/app_snackbar.dart';
import '../../domain/models/habit.dart';
import '../../domain/models/habit_form_arguments.dart';
import '../provider/habit_providers.dart';
import '../widgets/actions/habit_popup_menu.dart';

class HabitMenuHandler {
  const HabitMenuHandler._();

  static Future<void> handle({
    required BuildContext context,
    required WidgetRef ref,
    required Habit habit,
    required HabitMenuAction action,
  }) async {
    switch (action) {
      case HabitMenuAction.edit:
        context.pushNamed(
          'habit-form',
          extra: HabitFormArguments(
            habit: habit,
          ),
        );
        return;

      case HabitMenuAction.duplicate:
        context.pushNamed(
          'habit-form',
          extra: HabitFormArguments(
            habit: habit,
            duplicate: true,
          ),
        );
        return;

      case HabitMenuAction.archive:
        final confirmed = await showConfirmationDialog(
          context: context,
          title: 'Archive Habit',
          message: 'Archive "${habit.title}"?\n\n'
              'The habit will be removed from your active list. '
              'You can restore it later from Archived Habits.',
          confirmText: 'Archive',
        );

        if (!confirmed) return;

        await ref.read(habitNotifierProvider.notifier).archiveHabit(habit.id);

        if (!context.mounted) return;

        AppSnackbar.success(
          context,
          '"${habit.title}" archived.',
        );
        return;

      case HabitMenuAction.delete:
        // Permanent deletion is only supported from Archived Habits.
        if (!context.mounted) return;

        AppSnackbar.info(
          context,
          'Archive the habit first. Permanent deletion is available from Archived Habits.',
        );
        return;

      case HabitMenuAction.history:
        // TODO: Navigate to Habit History screen.
        return;
    }
  }
}
