import 'package:flutter/material.dart';

import '../../../../habits/domain/models/habit_log.dart';

import '../../../../../shared/ui/cards/app_section_card.dart';

class StatisticsActivitySection
    extends StatelessWidget {
  const StatisticsActivitySection({
    super.key,
    required this.logs,
  });

  final List<HabitLog> logs;

  @override
  Widget build(BuildContext context) {
    final recentLogs =
    logs.reversed.take(5).toList();

    return AppSectionCard(
      title: 'Recent Activity',
      child: recentLogs.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No activity yet',
          ),
        ),
      )
          : Column(
        children: recentLogs.map(
              (log) {
            return ListTile(
              dense: true,
              leading: const Icon(
                Icons.check_circle,
              ),
              title: Text(
                log.date.toString(),
              ),
              subtitle: Text(
                '+${log.xpEarned} XP',
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}