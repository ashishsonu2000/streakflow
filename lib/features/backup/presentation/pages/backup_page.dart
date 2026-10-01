import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entitlements/entitlement_provider.dart';
import '../../../../core/entitlements/premium_feature.dart';
import '../../../habits/presentation/provider/habit_providers.dart';
import '../../../premium/presentation/premium_gate.dart';
import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../notifications/presentation/providers/notification_service_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/services/backup_codec.dart';
import '../providers/backup_providers.dart';
import '../providers/csv_export_provider.dart';
import '../widgets/restore_preview_dialog.dart';


import '../providers/reset_application_provider.dart';


class BackupPage extends ConsumerWidget {
  const BackupPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Backup & Restore',
        ),
      ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.upload_file_outlined,
                ),
                title: const Text(
                  'Export Data',
                ),
                subtitle: const Text(
                  'Save your habits to a backup file',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () => _exportBackup(context, ref),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.download_outlined,
                ),
                title: const Text(
                  'Import Data',
                ),
                subtitle: const Text(
                  'Restore data from a backup file',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () => _importBackup(context, ref),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            // =========================================================
            // CSV EXPORT (Premium)
            // =========================================================

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.table_chart_outlined,
                ),
                title: const Text(
                  'Export to CSV',
                ),
                subtitle: const Text(
                  'Habits and history for spreadsheets',
                ),
                trailing: ref
                        .watch(featureAccessProvider)
                        .canUse(PremiumFeature.csvExport)
                    ? const Icon(Icons.chevron_right)
                    : const Icon(Icons.workspace_premium_outlined),
                onTap: () async {
                  if (!await PremiumGate.canUse(
                    context,
                    ref,
                    PremiumFeature.csvExport,
                  )) {
                    return;
                  }

                  try {
                    await ref.read(csvExportProvider)();
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not create the CSV export.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            const Padding(
              padding: EdgeInsets.only(
                left: 8,
                bottom: 8,
              ),
              child: Text(
                'Danger Zone',
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.delete_forever_outlined,
                ),
                title: const Text(
                  'Reset Application Data',
                ),
                subtitle: const Text(
                  'Delete all habits and activity history',
                ),
                onTap: () async {
                  final confirmed =
                  await showDialog<bool>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text(
                          'Reset Application Data',
                        ),
                        content: const Text(
                          'This action cannot be undone.\n\nAll habits, logs, statistics, achievements, and progress will be deleted.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                false,
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
                              'Delete',
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmed != true) {
                    return;
                  }

                  await ref
                      .read(
                    resetApplicationProvider,
                  )
                      .execute();

                  // The deleted habits' reminders would keep firing.
                  try {
                    await ref.read(notificationServiceProvider).cancelAll();
                  } catch (_) {}

                  _refreshAfterDataChange(ref);

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Application data deleted',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}

// =====================================================================
// EXPORT / IMPORT
// =====================================================================

void _showMessage(BuildContext context, String message) {
  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Data-backed screens that don't watch the database themselves.
void _refreshAfterDataChange(WidgetRef ref) {
  ref.invalidate(habitsProvider);
  ref.invalidate(allActiveHabitsProvider);
  ref.invalidate(archivedHabitsProvider);
  ref.invalidate(dashboardProvider);
  ref.invalidate(calendarProvider);
  ref.invalidate(profileProvider);
}

Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
  try {
    await ref.read(exportBackupProvider)();
  } catch (_) {
    if (context.mounted) {
      _showMessage(context, 'Could not create the backup.');
    }
  }
}

Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
  final BackupContents? contents;

  try {
    contents = await ref.read(restoreServiceProvider).pickBackup();
  } on BackupFormatException catch (error) {
    if (context.mounted) {
      _showMessage(context, error.message);
    }
    return;
  } catch (_) {
    if (context.mounted) {
      _showMessage(context, 'The backup file could not be opened.');
    }
    return;
  }

  if (contents == null || !context.mounted) {
    return;
  }

  if (contents.habits.isEmpty) {
    _showMessage(context, 'This backup has no habits to restore.');
    return;
  }

  final useCase = ref.read(restoreBackupUseCaseProvider);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => RestorePreviewDialog(
      contents: contents!,
      archivedForLimit: [
        for (final habit in useCase.habitsOverLimit(contents)) habit.title,
      ],
    ),
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  try {
    final result = await useCase(contents);

    _refreshAfterDataChange(ref);

    if (!context.mounted) {
      return;
    }

    final archived = result.archivedForLimit.length;

    _showMessage(
      context,
      'Restored ${result.habits} habit(s) and ${result.logs} history '
      'entr${result.logs == 1 ? 'y' : 'ies'}.'
      '${archived > 0 ? ' $archived archived (Free plan limit).' : ''}'
      '${result.reminderFailures > 0 ? ' Some reminders could not be set.' : ''}',
    );
  } catch (_) {
    if (context.mounted) {
      _showMessage(
        context,
        'Restore failed. Your current data was not changed.',
      );
    }
  }
}
