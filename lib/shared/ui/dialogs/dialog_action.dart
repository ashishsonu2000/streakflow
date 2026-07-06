import 'package:flutter/material.dart';

class DialogAction {
  const DialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;

  final bool isPrimary;
  final bool isDestructive;

  final IconData? icon;
}
