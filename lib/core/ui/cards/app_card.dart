import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.margin = EdgeInsets.zero,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    final card = Card(
      elevation: 0,

      margin: margin,

      clipBehavior:
      Clip.antiAlias,

      // =============================================================
      // THEME-AWARE SURFACE
      // =============================================================

      color: isDark
          ? colors.surfaceContainerLow
          : colors.surface,

      shape:
      RoundedRectangleBorder(
        borderRadius:
        AppRadius.large,

        side: BorderSide(
          color: isDark
              ? colors.outlineVariant
              .withValues(
            alpha: 0.80,
          )
              : colors.outlineVariant,

          width: 1,
        ),
      ),

      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      borderRadius:
      AppRadius.large,

      onTap: onTap,

      child: card,
    );
  }
}