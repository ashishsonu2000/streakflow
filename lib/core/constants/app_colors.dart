import 'package:flutter/material.dart';

/// Shared colors used across the application.
///
/// Theme colors should still come from
/// Theme.of(context).colorScheme.
///
/// These are only reusable semantic colors.
abstract final class AppColors {
  AppColors._();

  static const success = Color(0xFF2E7D32);

  static const warning = Color(0xFFF9A825);

  static const error = Color(0xFFC62828);

  static const info = Color(0xFF1565C0);

  static const streak = Color(0xFFFF6D00);

  static const xp = Color(0xFFFFC107);

  static const transparent = Colors.transparent;
}
