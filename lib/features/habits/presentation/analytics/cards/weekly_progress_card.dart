import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_card.dart';
import '../../../domain/models/weekly_progress.dart';

class WeeklyProgressCard extends StatelessWidget {
  const WeeklyProgressCard({
    super.key,
    required this.progress,
  });

  final WeeklyProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weekly Progress",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: progress.days.map((day) {
              return Column(
                children: [
                  Text(
                    day.day,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: day.completed
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      border: Border.all(
                        color: day.isToday
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      day.completed ? Icons.check : Icons.circle_outlined,
                      color: day.completed
                          ? Colors.white
                          : theme.colorScheme.outline,
                      size: 20,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            "${progress.completedCount}/7 days completed",
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
