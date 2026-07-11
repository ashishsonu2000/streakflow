import 'package:flutter/material.dart';

class HeatmapIndicator extends StatelessWidget {
  const HeatmapIndicator({
    super.key,
    required this.intensity,
  });

  final int intensity;

  @override
  Widget build(BuildContext context) {
    final Color color;

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
        color = Colors.grey.shade300;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
