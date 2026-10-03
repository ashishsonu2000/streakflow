import 'package:flutter/material.dart';

import '../../../domain/models/habit.dart';

class MilestoneCard extends StatelessWidget {
  const MilestoneCard({
    super.key,
    required this.habit,
  });

  final Habit habit;

  bool _isUnlocked(int value) {
    return habit.bestStreak >= value;
  }

  Widget _buildMilestone(
      BuildContext context,
      int value,
      ) {
    final unlocked = _isUnlocked(value);

    return Chip(
      avatar: Icon(
        unlocked
            ? Icons.check_circle
            : Icons.lock_outline,
        size: 18,
      ),
      label: Text(
        '$value Days',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Milestones',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),

            const SizedBox(
              height: 16,
            ),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildMilestone(
                  context,
                  1,
                ),
                _buildMilestone(
                  context,
                  3,
                ),
                _buildMilestone(
                  context,
                  7,
                ),
                _buildMilestone(
                  context,
                  14,
                ),
                _buildMilestone(
                  context,
                  30,
                ),
                _buildMilestone(
                  context,
                  100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}