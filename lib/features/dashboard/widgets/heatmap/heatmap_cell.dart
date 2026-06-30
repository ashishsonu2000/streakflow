import 'package:flutter/material.dart';

class HeatmapCell extends StatelessWidget {
  final int intensity;

  const HeatmapCell({
    super.key,
    required this.intensity,
  });

  Color _color(BuildContext context) {
    switch (intensity) {
      case 0:
        return Colors.grey.shade200;
      case 1:
        return Colors.green.shade100;
      case 2:
        return Colors.green.shade300;
      case 3:
        return Colors.green.shade600;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 18,
      height: 18,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: _color(context),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
