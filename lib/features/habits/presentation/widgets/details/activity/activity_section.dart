import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_section_card.dart';

import '../../../../domain/models/habit_log.dart';

import 'activity_empty.dart';
import 'activity_tile.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({
    super.key,
    required this.logs,
  });

  final List<HabitLog> logs;

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'Activity logs count: ${logs.length}',
    );

    for (final log in logs) {
      debugPrint(
        '${log.habitId} -> ${log.date}',
      );
    }

    return AppSectionCard(
      title: 'Recent Activity',
      child: logs.isEmpty
          ? const ActivityEmpty()
          : ListView.builder(
        shrinkWrap: true,
        physics:
        const NeverScrollableScrollPhysics(),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          return ActivityTile(
            log: logs[index],
          );
        },
      ),
    );
  }
}