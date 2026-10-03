import 'package:flutter/material.dart';

class HabitIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const HabitIcon({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: color.withValues(alpha: .15),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}
