import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.screen,
      vertical: AppSpacing.md,
    ),
  });

  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // =====================================================
                // TITLE
                // =====================================================

                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // =====================================================
                // SUBTITLE
                // =====================================================

                if (subtitle != null) ...[
                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    subtitle!,
                    style:
                    theme.textTheme.bodyMedium?.copyWith(
                      color:
                      colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // =========================================================
          // ACTION
          // =========================================================

          if (actionText != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor:
                colors.primary,
              ),
              child: Text(
                actionText!,
              ),
            ),
        ],
      ),
    );
  }
}