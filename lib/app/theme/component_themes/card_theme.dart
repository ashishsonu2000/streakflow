import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimensions.dart';

/// =============================================================
///
/// Card Theme
///
/// Used by every Card widget in the application.
///
/// =============================================================

class AppCardTheme {
  AppCardTheme._();

  static CardThemeData light = CardThemeData(
    elevation: AppDimensions.cardElevation,
    color: AppColors.surface,
    shadowColor: Colors.black.withValues(alpha: 0.06),
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: AppDimensions.cardRadius,
      side: const BorderSide(
        color: AppColors.border,
        width: 1,
      ),
    ),
  );

  static CardThemeData dark = CardThemeData(
    elevation: AppDimensions.cardElevation,
    color: AppColors.darkSurface,
    shadowColor: Colors.black.withValues(alpha: 0.20),
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: AppDimensions.cardRadius,
      side: BorderSide(
        color: Colors.white.withValues(alpha: 0.08),
        width: 1,
      ),
    ),
  );
}
