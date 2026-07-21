import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  static final card = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .05),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static final fab = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .12),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}
