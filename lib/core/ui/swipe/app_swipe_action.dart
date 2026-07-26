import 'package:flutter/material.dart';

class AppSwipeAction {
  const AppSwipeAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
}
