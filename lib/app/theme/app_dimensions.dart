import 'package:flutter/material.dart';

import 'app_radius.dart';
import 'app_spacing.dart';

class AppDimensions {
  AppDimensions._();

  // Padding

  static const EdgeInsets screenPadding = EdgeInsets.all(AppSpacing.lg);

  static const EdgeInsets cardPadding = EdgeInsets.all(AppSpacing.lg);

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.xl,
  );

  // Radius

  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(AppRadius.lg),
  );

  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(AppRadius.round),
  );

  static const BorderRadius inputRadius = BorderRadius.all(
    Radius.circular(AppRadius.md),
  );

  // Elevation

  static const double cardElevation = 1;

  static const double dialogElevation = 3;

  // Sizes

  static const double buttonHeight = 52;

  static const double appBarHeight = 64;

  static const double icon = 24;

  static const double avatar = 48;

  // app_dimensions.dart

  static const double heroRadius = 28;

  static const double heroPadding = 28;

  static const double heroHeight = 330;
}
