import 'package:flutter/material.dart';

class HabitFooter extends StatelessWidget {
  final int streak;
  final int points;

  const HabitFooter({
    super.key,
    required this.streak,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.local_fire_department,
          color: Colors.orange,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text("$streak Days"),
        const Spacer(),
        const Icon(
          Icons.stars,
          color: Colors.amber,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text("+$points XP"),
      ],
    );
  }
}
