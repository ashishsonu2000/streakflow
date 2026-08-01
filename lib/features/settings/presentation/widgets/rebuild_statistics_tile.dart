import 'package:flutter/material.dart';

import '../../../../core/database/isar_service.dart';
import '../../../habits/domain/services/habit_statistics_rebuilder.dart';
import 'settings_tile.dart';

class RebuildStatisticsTile extends StatelessWidget {
  const RebuildStatisticsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      leading: const Icon(Icons.refresh),
      title: 'Rebuild Statistics',
      subtitle: 'Recalculate streaks and analytics',
      onTap: () async {
        try {
          final db = await IsarService.instance.database;

          await HabitStatisticsRebuilder().rebuild(db);

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Statistics rebuilt successfully.',
              ),
            ),
          );
        } catch (error, stackTrace) {
          debugPrint('Failed to rebuild statistics');
          debugPrint(error.toString());
          debugPrintStack(stackTrace: stackTrace);

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to rebuild statistics.\n$error',
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
    );
  }
}
