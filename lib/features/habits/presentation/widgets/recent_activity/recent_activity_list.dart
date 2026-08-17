import 'package:flutter/material.dart';



import '../../../domain/models/habit_log.dart';
import 'recent_activity_tile.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({
    super.key,
    required this.logs,
  });

  final List<HabitLog> logs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        logs.length,
            (index) {
          return Column(
            children: [
              RecentActivityTile(
                log: logs[index],
              ),
              if (index != logs.length - 1)
                const Divider(),
            ],
          );
        },
      ),
    );
  }
}