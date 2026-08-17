import 'package:flutter/material.dart';

import '../../domain/models/achievement.dart';

import 'achievement_card.dart';

class AchievementSection
    extends StatelessWidget {
  const AchievementSection({
    super.key,
    required this.title,
    required this.achievements,
  });

  final String title;

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge,
        ),

        const SizedBox(height: 12),

        ...achievements.map(
              (achievement) {
            return Padding(
              padding:
              const EdgeInsets.only(
                bottom: 8,
              ),
              child: AchievementCard(
                achievement: achievement,
              ),
            );
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}