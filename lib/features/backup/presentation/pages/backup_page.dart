import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';


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
                onTap: () async {
                  // Export logic
                },
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
                onTap: () async {
                  // Import logic
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

                  ref.invalidate(
                    habitsProvider,
                  );

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