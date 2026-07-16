import 'package:flutter/material.dart';

import 'hero_level_badge.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({
    super.key,
    required this.level,
  });

  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.local_fire_department,
          color: Colors.orange,
          size: 34,
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            "CURRENT STREAK",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        HeroLevelBadge(level: level),
      ],
    );
  }
}
