import 'package:flutter/material.dart';

import '../../../../habits/domain/models/habit.dart';

class StreakRecoveryCard extends StatelessWidget {
  const StreakRecoveryCard({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Card(
      child: Padding(
        padding:
        const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Streak at Risk',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              '${habit.title} has a ${habit.currentStreak}-day streak.',
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Complete it today to avoid losing your progress.',
            ),
          ],
        ),
      ),
    );
  }
}