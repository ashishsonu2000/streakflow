import 'package:flutter/material.dart';

import '../app_colors.dart';

/// ===============================================================
///
/// Divider Theme
///
/// Provides a consistent style for all Divider widgets.
///
/// ===============================================================

class AppDividerTheme {
  AppDividerTheme._();

  static const DividerThemeData light = DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
    space: 1,
    indent: 0,
    endIndent: 0,
  );

  static DividerThemeData dark = DividerThemeData(
    color: Colors.white.withValues(alpha: 0.10),
    thickness: 1,
    space: 1,
    indent: 0,
    endIndent: 0,
  );
}
