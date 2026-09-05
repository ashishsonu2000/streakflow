import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

import 'component_themes/button_theme.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/divider_theme.dart';
import 'component_themes/progress_theme.dart';

class AppTheme {
  const AppTheme._();

  // ================================================================
  // LIGHT THEME
  // ================================================================

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: colorScheme,

      // ------------------------------------------------------------
      // Background / Surface
      // ------------------------------------------------------------

      scaffoldBackgroundColor: const Color(0xFFF6F8FC),

      cardColor: Colors.white,

      dividerColor: AppColors.divider.withValues(
        alpha: 0.60,
      ),

      // ------------------------------------------------------------
      // Text
      // ------------------------------------------------------------

      textTheme: AppTextTheme.textTheme,

      // ------------------------------------------------------------
      // AppBar
      // ------------------------------------------------------------

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: false,
      ),

      // ------------------------------------------------------------
      // Buttons
      // ------------------------------------------------------------

      elevatedButtonTheme:
      AppButtonTheme.elevatedButtonTheme,

      filledButtonTheme:
      AppButtonTheme.filledButtonTheme,

      outlinedButtonTheme:
      AppButtonTheme.outlinedButtonTheme,

      textButtonTheme:
      AppButtonTheme.textButtonTheme,

      // ------------------------------------------------------------
      // Cards
      // ------------------------------------------------------------

      cardTheme: AppCardTheme.light.copyWith(
        elevation: 2,
        shadowColor: Colors.black.withValues(
          alpha: 0.06,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      dividerTheme: AppDividerTheme.light,

      progressIndicatorTheme:
      AppProgressTheme.light,

      // ------------------------------------------------------------
      // FAB
      // ------------------------------------------------------------

      floatingActionButtonTheme:
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // ------------------------------------------------------------
      // Input
      // ------------------------------------------------------------

      inputDecorationTheme:
      InputDecorationTheme(
        filled: true,

        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.divider,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.divider,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),

        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),

        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),

        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
        ),
      ),

      // ------------------------------------------------------------
      // Chips
      // ------------------------------------------------------------

      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),

      // ------------------------------------------------------------
      // SnackBar
      // ------------------------------------------------------------

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ------------------------------------------------------------
      // Dialog
      // ------------------------------------------------------------

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // ------------------------------------------------------------
      // Bottom Sheet
      // ------------------------------------------------------------

      bottomSheetTheme:
      const BottomSheetThemeData(
        showDragHandle: true,
      ),

      // ------------------------------------------------------------
      // Navigation
      // ------------------------------------------------------------

      navigationBarTheme:
      NavigationBarThemeData(
        indicatorColor:
        AppColors.primary.withValues(
          alpha: 0.12,
        ),
      ),
    );
  }

  // ================================================================
  // DARK THEME
  // ================================================================

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    );

    // --------------------------------------------------------------
    // IMPORTANT
    //
    // AppTextTheme.textTheme was originally designed with dark
    // foreground colors for the light UI.
    //
    // Applying white display/body colors here prevents widgets
    // which use Theme.of(context).textTheme directly from becoming
    // black/invisible in dark mode.
    // --------------------------------------------------------------

    final darkTextTheme =
    AppTextTheme.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: colorScheme,

      // ------------------------------------------------------------
      // Background / Surface
      // ------------------------------------------------------------

      scaffoldBackgroundColor:
      const Color(0xFF0B0F1A),

      cardColor:
      const Color(0xFF121826),

      dividerColor:
      AppColors.darkDivider.withValues(
        alpha: 0.50,
      ),

      // ------------------------------------------------------------
      // FIXED DARK TEXT THEME
      // ------------------------------------------------------------

      textTheme: darkTextTheme,

      // ------------------------------------------------------------
      // AppBar
      // ------------------------------------------------------------

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor:
        colorScheme.onSurface,
        centerTitle: false,

        titleTextStyle:
        darkTextTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),

      // ------------------------------------------------------------
      // Buttons
      // ------------------------------------------------------------

      elevatedButtonTheme:
      AppButtonTheme.elevatedButtonTheme,

      filledButtonTheme:
      AppButtonTheme.filledButtonTheme,

      outlinedButtonTheme:
      AppButtonTheme.outlinedButtonTheme,

      textButtonTheme:
      AppButtonTheme.textButtonTheme,

      // ------------------------------------------------------------
      // Cards
      // ------------------------------------------------------------

      cardTheme: AppCardTheme.dark.copyWith(
        elevation: 0,

        color:
        const Color(0xFF121826),

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
        ),
      ),

      dividerTheme:
      AppDividerTheme.dark,

      progressIndicatorTheme:
      AppProgressTheme.dark,

      // ------------------------------------------------------------
      // FAB
      // ------------------------------------------------------------

      floatingActionButtonTheme:
      FloatingActionButtonThemeData(
        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,

        elevation: 4,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
        ),
      ),

      // ------------------------------------------------------------
      // Input
      // ------------------------------------------------------------

      inputDecorationTheme:
      InputDecorationTheme(
        filled: true,

        fillColor:
        const Color(0xFF121826),

        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide:
          BorderSide(
            color:
            colorScheme.outlineVariant,
          ),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide:
          BorderSide(
            color:
            colorScheme.outlineVariant,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide:
          BorderSide(
            color:
            colorScheme.primary,
            width: 2,
          ),
        ),

        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide:
          BorderSide(
            color:
            colorScheme.error,
          ),
        ),

        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide:
          BorderSide(
            color:
            colorScheme.error,
            width: 2,
          ),
        ),

        hintStyle:
        darkTextTheme.bodyMedium?.copyWith(
          color:
          colorScheme.onSurfaceVariant,
        ),

        labelStyle:
        darkTextTheme.bodyMedium?.copyWith(
          color:
          colorScheme.onSurfaceVariant,
        ),

        floatingLabelStyle:
        darkTextTheme.bodyMedium?.copyWith(
          color:
          colorScheme.primary,
        ),

        helperStyle:
        darkTextTheme.bodySmall?.copyWith(
          color:
          colorScheme.onSurfaceVariant,
        ),
      ),

      // ------------------------------------------------------------
      // Chips
      // ------------------------------------------------------------

      chipTheme: ChipThemeData(
        backgroundColor:
        const Color(0xFF121826),

        disabledColor:
        const Color(0xFF1B2333),

        selectedColor:
        colorScheme.primary.withValues(
          alpha: 0.18,
        ),

        secondarySelectedColor:
        colorScheme.primary.withValues(
          alpha: 0.18,
        ),

        side: BorderSide(
          color:
          colorScheme.outlineVariant
              .withValues(
            alpha: 0.70,
          ),
        ),

        labelStyle:
        darkTextTheme.labelLarge?.copyWith(
          color:
          colorScheme.onSurface,
        ),

        secondaryLabelStyle:
        darkTextTheme.labelLarge?.copyWith(
          color:
          colorScheme.onSurface,
        ),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(30),
        ),
      ),

      // ------------------------------------------------------------
      // SnackBar
      // ------------------------------------------------------------

      snackBarTheme:
      SnackBarThemeData(
        behavior:
        SnackBarBehavior.floating,

        elevation: 6,

        backgroundColor:
        const Color(0xFF1E293B),

        contentTextStyle:
        darkTextTheme.bodyMedium?.copyWith(
          color:
          Colors.white,
        ),

        actionTextColor:
        colorScheme.primary,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
      ),

      // ------------------------------------------------------------
      // Dialog
      // ------------------------------------------------------------

      dialogTheme:
      DialogThemeData(
        backgroundColor:
        const Color(0xFF121826),

        surfaceTintColor:
        Colors.transparent,

        titleTextStyle:
        darkTextTheme.titleLarge?.copyWith(
          color:
          colorScheme.onSurface,
          fontWeight:
          FontWeight.w700,
        ),

        contentTextStyle:
        darkTextTheme.bodyMedium?.copyWith(
          color:
          colorScheme.onSurfaceVariant,
        ),

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(24),
        ),
      ),

      // ------------------------------------------------------------
      // Bottom Sheet
      // ------------------------------------------------------------

      bottomSheetTheme:
      const BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor:
        Color(0xFF121826),
      ),

      // ------------------------------------------------------------
      // Navigation
      // ------------------------------------------------------------

      navigationBarTheme:
      NavigationBarThemeData(
        backgroundColor:
        Color(0xFF101116),

        indicatorColor:
        AppColors.primary.withValues(
          alpha: 0.25,
        ),

        labelTextStyle:
        WidgetStatePropertyAll(
          TextStyle(
            color:
            Colors.white,
            fontSize: 12,
            fontWeight:
            FontWeight.w500,
          ),
        ),

        iconTheme:
        WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return IconThemeData(
                color:
                colorScheme.onPrimary,
              );
            }

            return IconThemeData(
              color:
              colorScheme.onSurfaceVariant,
            );
          },
        ),
      ),

      // ------------------------------------------------------------
      // List Tiles
      // ------------------------------------------------------------

      listTileTheme:
      ListTileThemeData(
        textColor:
        colorScheme.onSurface,

        iconColor:
        colorScheme.onSurfaceVariant,

        subtitleTextStyle:
        darkTextTheme.bodySmall?.copyWith(
          color:
          colorScheme.onSurfaceVariant,
        ),

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
      ),

      // ------------------------------------------------------------
      // Radio
      // ------------------------------------------------------------

      radioTheme:
      RadioThemeData(
        fillColor:
        WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return colorScheme.primary;
            }

            return colorScheme.onSurfaceVariant;
          },
        ),
      ),

      // ------------------------------------------------------------
      // Switch
      // ------------------------------------------------------------

      switchTheme:
      SwitchThemeData(
        thumbColor:
        WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return colorScheme.onPrimary;
            }

            return colorScheme.onSurfaceVariant;
          },
        ),

        trackColor:
        WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return colorScheme.primary
                  .withValues(
                alpha: 0.55,
              );
            }

            return colorScheme.surfaceContainerHighest;
          },
        ),

        trackOutlineColor:
        WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return colorScheme.primary;
            }

            return colorScheme.outline;
          },
        ),
      ),

      // ------------------------------------------------------------
      // Checkbox
      // ------------------------------------------------------------

      checkboxTheme:
      CheckboxThemeData(
        fillColor:
        WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return colorScheme.primary;
            }

            return Colors.transparent;
          },
        ),

        checkColor:
        WidgetStatePropertyAll(
          colorScheme.onPrimary,
        ),

        side:
        BorderSide(
          color:
          colorScheme.outline,
        ),
      ),

      // ------------------------------------------------------------
      // Tooltip
      // ------------------------------------------------------------

      tooltipTheme:
      TooltipThemeData(
        decoration:
        BoxDecoration(
          color:
          const Color(0xFF1E293B),
          borderRadius:
          BorderRadius.circular(10),
        ),

        textStyle:
        const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}