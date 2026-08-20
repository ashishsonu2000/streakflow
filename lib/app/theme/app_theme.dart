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
  // Light Theme (UPGRADED)
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

      /// 🎨 Softer premium background
      scaffoldBackgroundColor: const Color(0xFFF6F8FC),

      /// 🧊 Card with depth
      cardColor: Colors.white,

      /// ✨ Better divider subtlety
      dividerColor: AppColors.divider.withValues(alpha:0.6),

      textTheme: AppTextTheme.textTheme,

      //------------------------------------------------------
      // ✨ AppBar (Premium minimal)
      //------------------------------------------------------

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: false,
      ),

      //------------------------------------------------------
      // Components
      //------------------------------------------------------

      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
      filledButtonTheme: AppButtonTheme.filledButtonTheme,
      outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,
      textButtonTheme: AppButtonTheme.textButtonTheme,

      /// 💎 Card upgraded
      cardTheme: AppCardTheme.light.copyWith(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha:0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      dividerTheme: AppDividerTheme.light,
      progressIndicatorTheme: AppProgressTheme.light,

      //------------------------------------------------------
      // FAB
      //------------------------------------------------------

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      //------------------------------------------------------
      // Input (More modern)
      //------------------------------------------------------

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.divider),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.divider),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),

      //------------------------------------------------------
      // Chips (pill style)
      //------------------------------------------------------

      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),

      //------------------------------------------------------
      // SnackBar (floating modern)
      //------------------------------------------------------

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 6,
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
      // Navigation
      //------------------------------------------------------

      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.primary.withValues(alpha:0.12),
      ),
    );
  }

  //------------------------------------------------------
  // Dark Theme (ULTRA PREMIUM)
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

      /// 🖤 AMOLED-ish background
      scaffoldBackgroundColor: const Color(0xFF0B0F1A),

      /// 🧊 Elevated surface
      cardColor: const Color(0xFF121826),

      dividerColor: AppColors.darkDivider.withValues(alpha:0.05),

      textTheme: AppTextTheme.textTheme,

      //------------------------------------------------------
      // AppBar
      //------------------------------------------------------

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),

      //------------------------------------------------------
      // Components
      //------------------------------------------------------

      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
      filledButtonTheme: AppButtonTheme.filledButtonTheme,
      outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,
      textButtonTheme: AppButtonTheme.textButtonTheme,

      /// 💎 Premium dark cards
      cardTheme: AppCardTheme.dark.copyWith(
        elevation: 0,
        color: const Color(0xFF121826),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      dividerTheme: AppDividerTheme.dark,
      progressIndicatorTheme: AppProgressTheme.dark,

      //------------------------------------------------------
      // FAB
      //------------------------------------------------------

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      //------------------------------------------------------
      // Input
      //------------------------------------------------------

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF121826),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      //------------------------------------------------------
      // Chips
      //------------------------------------------------------

      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF121826),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),

      //------------------------------------------------------
      // SnackBar
      //------------------------------------------------------

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      //------------------------------------------------------
      // Dialog
      //------------------------------------------------------

      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF121826),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      //------------------------------------------------------
      // Bottom Sheet
      //------------------------------------------------------

      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: Color(0xFF121826),
      ),

      //------------------------------------------------------
      // Navigation
      //------------------------------------------------------

      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.primary.withValues(alpha:0.25),
      ),
    );
  }
}