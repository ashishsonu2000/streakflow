import 'package:flutter/widgets.dart';

/// Application spacing tokens.
///
/// Usage:
/// ```dart
/// const SizedBox(height: AppSpacing.lg);
///
/// Padding(
///   padding: AppSpacing.screenPadding,
/// )
/// ```
abstract final class AppSpacing {
  AppSpacing._();

  static const double none = 0;

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}
