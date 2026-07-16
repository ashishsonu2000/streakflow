import 'package:flutter/material.dart';

class HabitStats extends StatelessWidget {
  const HabitStats({
    super.key,
    required this.currentStreak,
    required this.xp,
  });

  final int currentStreak;
  final int xp;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;

    return Row(
      children: [
        Icon(
          Icons.local_fire_department,
          color: Colors.orange,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          "$currentStreak Days",
          style: style,
        ),
        const SizedBox(width: 16),
        const Icon(
          Icons.stars,
          color: Colors.amber,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          "$xp XP",
          style: style,
        ),
      ],
    );
  }
}
