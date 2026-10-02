import 'package:flutter/material.dart';

// =====================================================================
// PERIOD SUMMARY
// =====================================================================

class HabitStatsPeriodSummaryCard
    extends StatelessWidget {
  const HabitStatsPeriodSummaryCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
    required this.icon,
  });

  final String title;
  final int completed;
  final int total;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    final percentage = total == 0
        ? 0.0
        : completed / total * 100;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
            Color(0xFF0B1738),
            Color(0xFF173574),
            Color(0xFF1E48A8),
          ]
              : [
            colors.primaryContainer,
            colors.primaryContainer
                .withValues(
              alpha: 0.72,
            ),
          ],
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: colors.primary.withValues(
            alpha: isDark ? 0.35 : 0.15,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: isDark ? 0.12 : 0.45,
              ),
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isDark
                  ? Colors.white
                  : colors.onPrimaryContainer,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
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
                    fontWeight:
                    FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : colors
                        .onPrimaryContainer,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '$completed of $total scheduled days',
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: isDark
                        ? Colors.white
                        .withValues(
                      alpha: 0.72,
                    )
                        : colors
                        .onPrimaryContainer
                        .withValues(
                      alpha: 0.72,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: theme
                .textTheme
                .headlineSmall
                ?.copyWith(
              fontWeight:
              FontWeight.w900,
              color: isDark
                  ? Colors.white
                  : colors.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
