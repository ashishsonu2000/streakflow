import 'package:flutter/material.dart';

class HeatmapCell extends StatelessWidget {
  const HeatmapCell({
    super.key,
    required this.intensity,
    required this.onTap,
  });

  final int intensity;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        color = theme.colorScheme.surfaceContainerHighest;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
