import 'package:flutter/material.dart';

TextTheme buildAppTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: base.headlineLarge?.copyWith(
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
    ),
    labelSmall: base.labelSmall?.copyWith(
      fontWeight: FontWeight.w600,
    ),
  );
}
