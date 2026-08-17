import 'package:flutter/material.dart';

import '../../domain/models/achievement.dart';

import 'achievement_card.dart';

class AchievementGrid
    extends StatelessWidget {
  const AchievementGrid({
    super.key,
    required this.achievements,
  });

  final List<Achievement>
  achievements;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: achievements.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: .9,
      ),
      itemBuilder: (context, index) {
        return AchievementCard(
          achievement:
          achievements[index],
        );
      },
    );
  }
}