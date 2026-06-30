import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';

/// ===============================================================
///
/// Generic Badge Widget
///
/// Used for:
/// - Level
/// - Achievement
/// - XP
/// - Status
/// - Future badges
///
/// ===============================================================

class AppBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  final Color backgroundColor;
  final Color foregroundColor;

  const AppBadge({
    super.key,
    required this.icon,
    required this.text,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: foregroundColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                ),
          ),
        ],
      ),
    );
  }
}
