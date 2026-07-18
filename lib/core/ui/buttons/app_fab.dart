import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class AppFab extends StatelessWidget {
  const AppFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.tooltip,
    this.heroTag,
    this.isMini = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Icon displayed on the FAB.
  final IconData icon;

  /// Optional label.
  ///
  /// If provided an Extended FAB is shown.
  final String? label;

  /// Callback when pressed.
  final VoidCallback onPressed;

  /// Tooltip shown on long press.
  final String? tooltip;

  /// Hero tag.
  final Object? heroTag;

  /// Mini FAB.
  final bool isMini;

  /// Override background color.
  final Color? backgroundColor;

  /// Override foreground color.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bg = backgroundColor ?? AppColors.primary;
    final fg = foregroundColor ?? Colors.white;

    if (label != null && label!.isNotEmpty) {
      return FloatingActionButton.extended(
        heroTag: heroTag,
        tooltip: tooltip,
        onPressed: onPressed,
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 3,
        icon: Icon(icon),
        label: Text(
          label!,
          style: theme.textTheme.labelLarge?.copyWith(
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return FloatingActionButton(
      heroTag: heroTag,
      tooltip: tooltip,
      mini: isMini,
      onPressed: onPressed,
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 3,
      child: Icon(icon),
    );
  }
}
