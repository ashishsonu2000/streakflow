import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Reusable horizontal and vertical gaps.
///
/// Usage:
///
/// AppGap.sm
/// AppGap.hLg
/// AppGap.custom(height: 50)
/// AppGap.custom(width: 12)
///
class AppGap {
  const AppGap._();

  //==================================================
  // Vertical Gaps
  //==================================================

  static const Widget none = SizedBox.shrink();

  static const Widget xxs = SizedBox(
    height: AppSpacing.xxs,
  );

  static const Widget xs = SizedBox(
    height: AppSpacing.xs,
  );

  static const Widget sm = SizedBox(
    height: AppSpacing.sm,
  );

  static const Widget md = SizedBox(
    height: AppSpacing.md,
  );

  static const Widget lg = SizedBox(
    height: AppSpacing.lg,
  );

  static const Widget xl = SizedBox(
    height: AppSpacing.xl,
  );

  static const Widget xxl = SizedBox(
    height: AppSpacing.xxl,
  );

  static const Widget xxxl = SizedBox(
    height: AppSpacing.xxxl,
  );

  //==================================================
  // Horizontal Gaps
  //==================================================

  static const Widget hXxs = SizedBox(
    width: AppSpacing.xxs,
  );

  static const Widget hXs = SizedBox(
    width: AppSpacing.xs,
  );

  static const Widget hSm = SizedBox(
    width: AppSpacing.sm,
  );

  static const Widget hMd = SizedBox(
    width: AppSpacing.md,
  );

  static const Widget hLg = SizedBox(
    width: AppSpacing.lg,
  );

  static const Widget hXl = SizedBox(
    width: AppSpacing.xl,
  );

  static const Widget hXxl = SizedBox(
    width: AppSpacing.xxl,
  );

  static const Widget hXxxl = SizedBox(
    width: AppSpacing.xxxl,
  );

  //==================================================
  // Custom
  //==================================================

  static Widget custom({
    double height = 0,
    double width = 0,
  }) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  //==================================================
  // Square Space
  //==================================================

  static Widget square(double size) {
    return SizedBox(
      width: size,
      height: size,
    );
  }
}
