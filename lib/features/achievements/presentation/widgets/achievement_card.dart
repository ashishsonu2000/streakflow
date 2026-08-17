import 'package:flutter/material.dart';

import '../../domain/models/achievement.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({
    super.key,
    required this.achievement,
  });

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            achievement.icon,
          ),
        ),
        title: Text(
          achievement.title,
        ),
        subtitle: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description,
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: achievement.progress,
            ),

            const SizedBox(height: 4),

            Text(
              '${achievement.currentValue}/${achievement.targetValue}',
            ),
          ],
        ),
        trailing: Icon(
          achievement.unlocked
              ? Icons.lock_open
              : Icons.lock,
        ),
      ),
    );
  }
}