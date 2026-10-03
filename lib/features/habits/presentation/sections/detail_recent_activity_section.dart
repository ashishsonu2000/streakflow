import 'package:flutter/material.dart';

import '../../domain/models/habit_detail.dart';
import '../widgets/activity_timeline_tile.dart';

class DetailRecentActivitySection extends StatelessWidget {
  const DetailRecentActivitySection({
    super.key,
    required this.detail,
  });

  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    final logs = detail.logs.take(10).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Activity",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            if (logs.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "No activity yet",
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.length,
                itemBuilder: (_, index) {
                  return ActivityTimelineTile(
                    log: logs[index],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
