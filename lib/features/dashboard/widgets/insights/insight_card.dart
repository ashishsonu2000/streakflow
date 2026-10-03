import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        // =========================================================
        // CARD BACKGROUND
        // =========================================================

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            colors.surfaceContainer,
            colors.surfaceContainerLow,
          ]
              : const [
            Color(0xFFF8FAFC),
            Color(0xFFEEF4FA),
          ],
        ),

        borderRadius:
        BorderRadius.circular(18),

        // =========================================================
        // BORDER
        // =========================================================

        border: Border.all(
          color: isDark
              ? colors.outlineVariant.withValues(
            alpha: 0.70,
          )
              : const Color(0xFF2563EB).withValues(
            alpha: 0.16,
          ),
          width: 1.0,
        ),

        // =========================================================
        // SHADOW
        // =========================================================

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.16 : 0.025,
            ),
            blurRadius: isDark ? 12 : 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =========================================================
          // ICON
          // =========================================================

          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              color: color.withValues(
                alpha: isDark ? 0.16 : 0.10,
              ),

              borderRadius:
              BorderRadius.circular(13),

              border: Border.all(
                color: color.withValues(
                  alpha: isDark ? 0.24 : 0.08,
                ),
              ),
            ),

            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          // =========================================================
          // CONTENT
          // =========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------
                // TITLE
                // ---------------------------------------------------

                Text(
                  title,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    color: colors.onSurface,
                    fontWeight:
                    FontWeight.w700,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 5),

                // ---------------------------------------------------
                // MESSAGE
                // ---------------------------------------------------

                Text(
                  message,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    colors.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}