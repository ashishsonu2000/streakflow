import 'package:flutter/material.dart';

class HeroProgress extends StatelessWidget {
  const HeroProgress({
    super.key,
    required this.xpProgress,
    required this.totalXP,
    required this.nextLevelXP,
  });

  final double xpProgress;
  final int totalXP;
  final int nextLevelXP;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: xpProgress,
            minHeight: 10,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation(
              Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$totalXP XP",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            Text(
              "Next: $nextLevelXP XP",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
