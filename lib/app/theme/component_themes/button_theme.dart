import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimensions.dart';
import '../app_text_styles.dart';

/// ===============================================================
///
/// Button Theme
///
/// Contains:
/// - Elevated Button
/// - Filled Button
/// - Outlined Button
/// - Text Button
///
/// Used throughout the application.
///
/// ===============================================================

class AppButtonTheme {
  AppButtonTheme._();

  // ---------------------------------------------------------------------------
  // Elevated Button
  // ---------------------------------------------------------------------------

  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      textStyle: AppTextStyles.labelLarge,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.buttonRadius,
      ),
      padding: AppDimensions.cardPadding,
    ),
  );

  // ---------------------------------------------------------------------------
  // Filled Button
  // ---------------------------------------------------------------------------

  static FilledButtonThemeData filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      textStyle: AppTextStyles.labelLarge,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.buttonRadius,
      ),
    ),
  );

  // ---------------------------------------------------------------------------
  // Outlined Button
  // ---------------------------------------------------------------------------

  static OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
      foregroundColor: AppColors.primary,
      side: const BorderSide(
        color: AppColors.primary,
        width: 1.2,
      ),
      textStyle: AppTextStyles.titleMedium,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.buttonRadius,
      ),
    ),
  );

  // ---------------------------------------------------------------------------
  // Text Button
  // ---------------------------------------------------------------------------

  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: AppTextStyles.titleMedium,
    ),
  );
}
