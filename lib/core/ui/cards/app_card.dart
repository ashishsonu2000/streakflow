import 'package:flutter/material.dart';

import '../design/app_elevation.dart';
import '../design/app_radius.dart';
import '../design/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(
      AppSpacing.cardPadding,
    ),
    this.margin = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin,
      child: Material(
        color: theme.colorScheme.surface,
        elevation: AppElevation.low,
        shadowColor: theme.shadowColor.withValues(alpha: 0.08),
        borderRadius: AppRadius.lg,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lg,
          child: Container(
            width: double.infinity,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: AppRadius.lg,
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
