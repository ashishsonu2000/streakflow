import 'package:flutter/material.dart';

import '../../domain/models/achievement.dart';

class AchievementUnlockDialog extends StatelessWidget {
  const AchievementUnlockDialog({
    super.key,
    required this.achievement,
  });

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '🏆 Achievement Unlocked!',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            achievement.icon,
            size: 64,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            achievement.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            achievement.description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            'Awesome!',
          ),
        ),
      ],
    );
  }
}