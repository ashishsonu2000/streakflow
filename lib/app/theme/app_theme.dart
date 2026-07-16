import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

import 'component_themes/button_theme.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/divider_theme.dart';
import 'component_themes/progress_theme.dart';

class AppTheme {
  const AppTheme._();

  //------------------------------------------------------
  // Light Theme
  //------------------------------------------------------

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.background,

      cardColor: AppColors.surface,

      dividerColor: AppColors.divider,

      textTheme: AppTextTheme.textTheme,

      //------------------------------------------------------
      // Components
      //------------------------------------------------------

      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,

      filledButtonTheme: AppButtonTheme.filledButtonTheme,

      outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,

      textButtonTheme: AppButtonTheme.textButtonTheme,

      cardTheme: AppCardTheme.light,

      dividerTheme: AppDividerTheme.light,

      progressIndicatorTheme: AppProgressTheme.light,

      //------------------------------------------------------
      // FAB
      //------------------------------------------------------

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      //------------------------------------------------------
      // Input
      //------------------------------------------------------

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.divider,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.divider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),

      //------------------------------------------------------
      // Chips
      //------------------------------------------------------

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      //------------------------------------------------------
      // SnackBar
      //------------------------------------------------------

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      //------------------------------------------------------
      // Dialog
      //------------------------------------------------------

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      //------------------------------------------------------
      // Bottom Sheet
      //------------------------------------------------------

      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
      ),

      //------------------------------------------------------
      // Navigation Bar
      //------------------------------------------------------

      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.primary.withOpacity(.15),
      ),
    );
  }

  //------------------------------------------------------
  // Dark Theme
  //------------------------------------------------------

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkDivider,
      textTheme: AppTextTheme.textTheme,
      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
      filledButtonTheme: AppButtonTheme.filledButtonTheme,
      outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,
      textButtonTheme: AppButtonTheme.textButtonTheme,
      cardTheme: AppCardTheme.dark,
      dividerTheme: AppDividerTheme.dark,
      progressIndicatorTheme: AppProgressTheme.dark,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.primary.withOpacity(.25),
      ),
    );
  }
}
