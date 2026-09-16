import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/collections/profile_collection.dart';
import '../../../../core/database/isar_service.dart';
import '../../../habits/data/entities/habit_entity.dart';
import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class ClearDataTile extends ConsumerWidget {
  const ClearDataTile({
    super.key,
  });

  Future<void> _confirm(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Clear all data?',
          ),
          content: const Text(
            'All habits, logs, statistics, achievements, and profile data will be deleted. This cannot be undone.',
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

    if (result != true) {
      return;
    }

    try {
      final db = await IsarService.instance.database;

      await db.writeTxn(() async {
        await db.habitEntitys.clear();
        await db.habitLogEntitys.clear();
        await db.profileCollections.clear();
      });

      // Keeps in-memory profile/onboarding state in sync with the
      // now-empty database instead of only relying on Isar's watch
      // streams (which the habit lists already react to).
      await ref.read(profileProvider.notifier).resetOnboarding();

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'All data has been cleared.',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to clear data.\n$error',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return ListTile(
      leading: const Icon(
        Icons.delete_outline,
      ),
      title: const Text(
        'Clear All Data',
      ),
      subtitle: const Text(
        'Reset the application',
      ),
      onTap: () {
        _confirm(
          context,
          ref,
        );
      },
    );
  }
}
