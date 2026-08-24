import 'package:flutter/material.dart';

import '../../domain/models/restore_preview.dart';

class RestorePreviewDialog
    extends StatelessWidget {
  const RestorePreviewDialog({
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
            'Version: ${preview.version}',
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            'Profile: ${preview.profileName}',
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            'Habits: ${preview.habitCount}',
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            'Logs: ${preview.logCount}',
          ),

          const SizedBox(
            height: 20,
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