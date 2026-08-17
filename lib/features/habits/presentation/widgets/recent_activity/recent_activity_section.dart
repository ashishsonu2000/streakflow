import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_section_card.dart';

import '../../../domain/models/habit_log.dart';

import 'recent_activity_tile.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({
    super.key,
    required this.logs,
  });

  final List<HabitLog> logs;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Recent Activity',
      child: logs.isEmpty
          ? const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            'No activity yet.',
          ),
        ),
      )
          : ListView.separated(
        shrinkWrap: true,
        physics:
        const NeverScrollableScrollPhysics(),
        itemCount: logs.length,
        separatorBuilder: (_, __) =>
        const Divider(),
        itemBuilder: (_, index) {
          return RecentActivityTile(
            log: logs[index],
          );
        },
      ),
    );
  }
}