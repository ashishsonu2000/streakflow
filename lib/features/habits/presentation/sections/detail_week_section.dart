import 'package:flutter/material.dart';

import '../../domain/models/habit_detail.dart';
import '../widgets/week_day_chip.dart';

class DetailWeeklySection extends StatelessWidget {
  const DetailWeeklySection({
    super.key,
    required this.detail,
  });

  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    final weekly = detail.weeklyProgress;

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
              "Weekly Progress",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "${weekly.completedCount} of ${weekly.days.length} days completed",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekly.days
                  .map(
                    (day) => WeekDayChip(
                      day: day.day,
                      completed: day.completed,
                      isToday: day.isToday,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: weekly.percentage,
              ),
              duration: const Duration(milliseconds: 800),
              builder: (_, value, __) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${(value * 100).round()}%",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
