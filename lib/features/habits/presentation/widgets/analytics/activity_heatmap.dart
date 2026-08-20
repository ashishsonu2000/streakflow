import 'package:flutter/material.dart';

import '../../../domain/models/analytics/heatmap_day.dart';

class ActivityHeatmap extends StatelessWidget {
  const ActivityHeatmap({
    super.key,
    required this.days,
  });

  final List<HeatmapDay> days;

  static const int _columns = 16;
  static const double _cellSize = 10;
  static const double _spacing = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Heatmap',
              style: theme.textTheme.titleMedium
                  ?.copyWith(
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Center(
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: days.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _columns,
                  crossAxisSpacing:
                  _spacing,
                  mainAxisSpacing:
                  _spacing,
                  childAspectRatio: 1,
                ),
                itemBuilder:
                    (context, index) {
                  final day =
                  days[index];

                  return Tooltip(
                    message:
                    '${day.date.day}/${day.date.month}/${day.date.year}',
                    child: Container(
                      width: _cellSize,
                      height: _cellSize,
                      decoration:
                      BoxDecoration(
                        color: day
                            .isCompleted
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}