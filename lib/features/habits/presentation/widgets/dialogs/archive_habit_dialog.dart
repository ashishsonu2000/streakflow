import 'package:flutter/material.dart';

class ArchiveHabitDialog extends StatelessWidget {
  const ArchiveHabitDialog({
    super.key,
    required this.habitTitle,
  });

  final String habitTitle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.archive_outlined),
      title: const Text('Archive Habit'),
      content: Text(
        'Archive "$habitTitle"?\n\n'
        'The habit will disappear from your active list, but you can restore it later.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.archive),
          label: const Text('Archive'),
        ),
      ],
    );
  }
}
