import 'package:flutter/material.dart';

import '../../domain/models/restore_preview.dart';

class RestoreDialog
    extends StatelessWidget {
  const RestoreDialog({
    super.key,
    required this.preview,
  });

  final RestorePreview preview;

  @override
  Widget build(
      BuildContext context,
      ) {
    return AlertDialog(
      title: const Text(
        'Restore Backup',
      ),
      content: Column(
        mainAxisSize:
        MainAxisSize.min,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Profile: ${preview.profileName}',
          ),
          Text(
            'Habits: ${preview.habitCount}',
          ),
          Text(
            'Logs: ${preview.logCount}',
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Existing data will be replaced.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            'Cancel',
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              true,
            );
          },
          child: const Text(
            'Restore',
          ),
        ),
      ],
    );
  }
}