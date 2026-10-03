import 'package:flutter/material.dart';

class MetricIcon extends StatelessWidget {
  const MetricIcon({
    super.key,
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 26,
      ),
    );
  }
}
