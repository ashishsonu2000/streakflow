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
        const Icon(
          Icons.local_fire_department_rounded,
          color: Colors.deepOrange,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          "$currentStreak Day Streak",
          style: style,
        ),
        const Spacer(),
        const Icon(
          Icons.stars_rounded,
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
