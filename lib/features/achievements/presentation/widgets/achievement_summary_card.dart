import 'package:flutter/material.dart';

class AchievementSummaryCard extends StatelessWidget {
  const AchievementSummaryCard({
    super.key,
    required this.unlocked,
    required this.total,
  });

  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress =
    total == 0
        ? 0.0
        : unlocked / total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_events,
              size: 56,
            ),

            const SizedBox(height: 16),

            const Text(
              'Achievement Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '$unlocked / $total unlocked',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(
              value: progress,
            ),

            const SizedBox(height: 8),

            Text(
              '${(progress * 100).round()}%',
            ),
          ],
        ),
      ),
    );
  }
}