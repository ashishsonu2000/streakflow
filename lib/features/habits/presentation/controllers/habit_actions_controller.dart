import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit.dart';

final habitActionsControllerProvider = Provider<HabitActionsController>(
  (ref) => HabitActionsController(ref),
);

class HabitActionsController {
  HabitActionsController(this.ref);

  final Ref ref;

  Future<void> edit(
    BuildContext context,
    String habitId,
  ) async {}

  Future<void> archive(
    BuildContext context,
    Habit habit,
  ) async {}

  Future<void> delete(
    BuildContext context,
    Habit habit,
  ) async {}

  Future<void> history(
    BuildContext context,
    Habit habit,
  ) async {}
}
