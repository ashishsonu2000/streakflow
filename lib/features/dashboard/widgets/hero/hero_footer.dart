import 'package:flutter/material.dart';

import '../../../../core/ui/badges/achievement_badge.dart';
import '../../../../core/ui/badges/level_badge.dart';

class HeroFooter extends StatelessWidget {
  final int level;
  final String achievement;

  const HeroFooter({
    super.key,
    required this.level,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LevelBadge(level: level),
        const SizedBox(height: 12),
        AchievementBadge(
          achievement: achievement,
        ),
      ],
    );
  }
}
