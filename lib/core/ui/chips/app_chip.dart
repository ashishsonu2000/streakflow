import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.compact = true,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon == null
          ? null
          : Icon(
              icon,
              size: 16,
              color: color,
            ),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: compact ? 12 : 14,
        ),
      ),
      side: BorderSide.none,
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      backgroundColor: color.withValues(alpha: .12),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
