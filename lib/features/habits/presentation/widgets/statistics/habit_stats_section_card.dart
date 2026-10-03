import 'package:flutter/material.dart';

// =====================================================================
// SECTION CARD
// =====================================================================

class HabitStatsSectionCard extends StatelessWidget {
  const HabitStatsSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            colors.surfaceContainer,
            colors.surfaceContainerLow,
          ]
              : [
            colors.surface,
            const Color(0xFFF7FAFF),
          ],
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant
              .withValues(
            alpha: isDark ? 0.70 : 0.65,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.025,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              color: colors.onSurface,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }
}
