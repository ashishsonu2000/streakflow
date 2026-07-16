import 'package:flutter/material.dart';

class HeatmapIndicator extends StatelessWidget {
  const HeatmapIndicator({
    super.key,
    required this.intensity,
    this.size = 8,
  });

  final int intensity;

  final double size;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (intensity) {
      case 4:
        color = Colors.green.shade700;
        break;

      case 3:
        color = Colors.green.shade500;
        break;

      case 2:
        color = Colors.green.shade300;
        break;

      case 1:
        color = Colors.green.shade100;
        break;

      default:
        color = Theme.of(context).colorScheme.surfaceContainerHighest;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
