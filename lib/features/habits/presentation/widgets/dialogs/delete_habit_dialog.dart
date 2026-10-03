import 'package:flutter/material.dart';

import '../../../domain/models/habit.dart';

Future<bool?> showDeleteHabitDialog(
  BuildContext context,
  Habit habit,
) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Habit'),
      content: Text(
        'Delete "${habit.title}"?\n\nThis action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
