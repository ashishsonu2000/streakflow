import 'package:flutter/material.dart';

import '../../../domain/models/analytics/heatmap_day.dart';





class ActivityHeatmap extends StatelessWidget {
  const ActivityHeatmap({
    super.key,
    required this.days,
  });

  final List<HeatmapDay> days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Heatmap',
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: days.map(
                    (day) {
                  return Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: day.isCompleted
                          ? theme
                          .colorScheme
                          .primary
                          : theme
                          .colorScheme
                          .surfaceContainerHighest,
                      borderRadius:
                      BorderRadius.circular(
                        2,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}