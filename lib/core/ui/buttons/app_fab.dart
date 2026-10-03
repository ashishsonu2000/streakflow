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

  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final String? tooltip;
  final Object? heroTag;
  final bool isMini;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bg =
        backgroundColor ?? AppColors.primary;

    final fg =
        foregroundColor ?? Colors.white;

    // ===============================================================
    // EXTENDED FAB
    // ===============================================================

    if (label != null && label!.isNotEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(18),

          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFF172554),
              bg,
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: bg.withValues(
                alpha: 0.22,
              ),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            onTap: onPressed,
            borderRadius:
            BorderRadius.circular(18),

            child: Container(
              height: 52,

              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
              ),

              child: Row(
                mainAxisSize:
                MainAxisSize.min,

                children: [
                  Icon(
                    icon,
                    color: fg,
                    size: 21,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Text(
                    label!,
                    style: theme
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                      color: fg,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ===============================================================
    // NORMAL / MINI FAB
    // ===============================================================

    return Container(
      width: isMini ? 44 : 56,
      height: isMini ? 44 : 56,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF172554),
            bg,
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: bg.withValues(
              alpha: 0.22,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onPressed,
          borderRadius:
          BorderRadius.circular(999),

          child: Tooltip(
            message: tooltip ?? '',
            child: Icon(
              icon,
              color: fg,
              size: isMini ? 20 : 25,
            ),
          ),
        ),
      ),
    );
  }
}