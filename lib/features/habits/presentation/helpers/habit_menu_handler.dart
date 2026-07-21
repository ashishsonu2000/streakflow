import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/habit.dart';
import '../../domain/models/habit_form_arguments.dart';
import '../widgets/actions/habit_popup_menu.dart';

class HabitMenuHandler {
  const HabitMenuHandler._();

  static Future<void> handle(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
    HabitMenuAction action,
  ) async {
    switch (action) {
      case HabitMenuAction.edit:
        _edit(context, habit);
        break;

      case HabitMenuAction.history:
        _history(context, habit);
        break;

      case HabitMenuAction.archive:
        await _archive(context, ref, habit);
        break;

      case HabitMenuAction.delete:
        await _delete(context, ref, habit);
        break;
      case HabitMenuAction.duplicate:
        context.pushNamed(
          'habit-form',
          extra: HabitFormArguments(
            habit: habit,
            duplicate: true,
          ),
        );
        break;
    }
  }

  static void _edit(BuildContext context, Habit habit) {
    context.pushNamed('habit-detail', extra: habit);
  }

  static void _history(BuildContext context, Habit habit) {
    // TODO: Navigate to history page
  }

  static Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
  ) async {
    // TODO
  }

  static Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
  ) async {
    // TODO
  }
}
