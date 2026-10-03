import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_section_card.dart';

import '../../../../domain/models/habit_log.dart';

import '../../recent_activity/recent_activity_tile.dart';
import 'activity_empty.dart';


class ActivitySection extends StatelessWidget {
  const ActivitySection({
    super.key,
    required this.logs,
  });

  final List<HabitLog> logs;

  @override
  Widget build(BuildContext context) {
    AppLogger.log(
      'Activity logs count: ${logs.length}',
    );

    for (final log in logs) {
      AppLogger.log(
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
          return RecentActivityTile(
            log: logs[index],
          );
        },
      ),
    );
  }
}