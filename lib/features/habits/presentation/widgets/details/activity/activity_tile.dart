import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/habit_log.dart';

import 'activity_timeline_indicator.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.log,
  });

  final HabitLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final completed =
        log.completedAt != null;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        ActivityTimelineIndicator(
          completed: completed,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Padding(
            padding:
            const EdgeInsets.only(
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(log.date),
                  style: theme
                      .textTheme
                      .titleSmall,
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  completed
                      ? 'Completed'
                      : 'Missed',
                ),

                const SizedBox(
                  height: 8,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    Text(
                      '${log.xpEarned} XP',
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    const Icon(
                      Icons.timer,
                      size: 16,
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    Text(
                      '${log.durationMinutes} min',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}