import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

import 'component_themes/button_theme.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/divider_theme.dart';
import 'component_themes/progress_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.surface,
        dividerColor: AppColors.divider,
        textTheme: AppTextTheme.textTheme,
        elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
        filledButtonTheme: AppButtonTheme.filledButtonTheme,
        outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,
        textButtonTheme: AppButtonTheme.textButtonTheme,
        cardTheme: AppCardTheme.light,
        dividerTheme: AppDividerTheme.light,
        progressIndicatorTheme: AppProgressTheme.light);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkSurface,
        textTheme: AppTextTheme.textTheme,
        elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
        filledButtonTheme: AppButtonTheme.filledButtonTheme,
        outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,
        textButtonTheme: AppButtonTheme.textButtonTheme,
        cardTheme: AppCardTheme.dark,
        dividerTheme: AppDividerTheme.dark,
        progressIndicatorTheme: AppProgressTheme.dark);
  }
}
