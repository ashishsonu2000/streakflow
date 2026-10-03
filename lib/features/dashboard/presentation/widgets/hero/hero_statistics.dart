import 'package:flutter/material.dart';

class HeroStatistics extends StatelessWidget {
  const HeroStatistics({
    super.key,
    required this.level,
    required this.xp,
    required this.bestStreak,
  });

  final int level;
  final int xp;
  final int bestStreak;

  @override
  Widget build(BuildContext context) {
    Widget item(
      String title,
      String value,
    ) {
      return Expanded(
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      );
    }

    return Row(
      children: [
        item("Level", "$level"),
        item("XP", "$xp"),
        item("Best", "$bestStreak"),
      ],
    );
  }
}
