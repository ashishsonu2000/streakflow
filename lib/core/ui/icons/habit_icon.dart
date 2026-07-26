import 'package:flutter/material.dart';

class HabitIcon extends StatelessWidget {
  const HabitIcon({
    super.key,
    required this.iconCodePoint,
    required this.color,
    this.size = 44,
  });

  final int iconCodePoint;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: color.withValues(alpha: .15),
        ),
      ),
      child: Icon(
        IconData(
          iconCodePoint,
          fontFamily: 'MaterialIcons',
        ),
        color: color,
        size: size * .55,
      ),
    );
  }
}
