import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_font_weights.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 48,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textPrimary,
    letterSpacing: -1,
  );

  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 40,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.textPrimary,
  );

  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textSecondary,
  );

  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: AppFontWeights.semiBold,
    color: Colors.white,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textSecondary,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textHint,
  );
}
