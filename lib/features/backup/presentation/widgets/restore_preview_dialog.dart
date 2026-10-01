import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/services/backup_codec.dart';

/// Shows what a backup contains before restoring it. Pops `true` when
/// the user confirms.
class RestorePreviewDialog
    extends StatelessWidget {
  const RestorePreviewDialog({
    super.key,
    required this.contents,
    required this.archivedForLimit,
  });

  final BackupContents contents;

  /// Active habits that will be archived because of the plan limit.
  final List<String> archivedForLimit;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final exportedAt = contents.exportedAt;
    final profileName = contents.profile?.name ?? '';

    return AlertDialog(
      title: const Text(
        'Restore backup?',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            if (exportedAt != null)
              Text(
                'Created: ${DateFormat('d MMM yyyy, HH:mm').format(exportedAt)}',
              ),

            if (profileName.isNotEmpty)
              Text(
                'Profile: $profileName',
              ),

            Text(
              'Habits: ${contents.habits.length} '
                  '(${contents.activeHabitCount} active)',
            ),

            Text(
              'History entries: ${contents.logs.length}',
            ),

            if (contents.skippedHabits > 0 ||
                contents.skippedLogs > 0) ...[
              const SizedBox(
                height: 12,
              ),
              Text(
                'Damaged or incomplete entries will be skipped: '
                    '${contents.skippedHabits} habit(s), '
                    '${contents.skippedLogs} history entr'
                    '${contents.skippedLogs == 1 ? 'y' : 'ies'}.',
                style: theme.textTheme.bodySmall,
              ),
            ],

            if (contents.formatVersion < BackupCodec.formatVersion) ...[
              const SizedBox(
                height: 12,
              ),
              Text(
                'This backup is from an earlier version. Weekly and '
                    'monthly habits will use their start day; check their '
                    'schedule after restoring.',
                style: theme.textTheme.bodySmall,
              ),
            ],

            if (archivedForLimit.isNotEmpty) ...[
              const SizedBox(
                height: 12,
              ),
              Text(
                'The Free plan allows fewer active habits, so these will '
                    'be restored as archived: '
                    '${archivedForLimit.join(', ')}.',
                style: theme.textTheme.bodySmall,
              ),
            ],

            const SizedBox(
              height: 16,
            ),

            Text(
              'All current habits and history on this device will be '
                  'replaced. This cannot be undone.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
            'Replace & Restore',
          ),
        ),
      ],
    );
  }
}
