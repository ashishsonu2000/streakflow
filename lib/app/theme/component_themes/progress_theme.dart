import 'package:flutter/material.dart';

import '../app_colors.dart';

/// ===============================================================
///
/// Progress Indicator Theme
///
/// Used by:
/// • LinearProgressIndicator
/// • CircularProgressIndicator
///
/// ===============================================================

class AppProgressTheme {
  AppProgressTheme._();

  static ProgressIndicatorThemeData light = const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.surfaceVariant,
    circularTrackColor: AppColors.surfaceVariant,
    strokeWidth: 5,
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  );

  static ProgressIndicatorThemeData dark = ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: Colors.white.withValues(alpha: 0.08),
    circularTrackColor: Colors.white.withValues(alpha: 0.08),
    strokeWidth: 5,
    borderRadius: const BorderRadius.all(
      Radius.circular(100),
    ),
  );
}
