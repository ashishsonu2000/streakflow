import 'package:flutter/material.dart';

import 'habit_stats_formatters.dart';

// =====================================================================
// HABIT HEADER
// =====================================================================

class HabitStatsHeader extends StatelessWidget {
  const HabitStatsHeader({
    super.key,
    required this.title,
    required this.startDate,
  });

  final String title;
  final DateTime startDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
            Color(0xFF0B1738),
            Color(0xFF132C68),
            Color(0xFF1B429F),
          ]
              : const [
            Color(0xFFE8E9FF),
            Color(0xFFDCE5FF),
          ],
        ),
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color: colors.primary.withValues(
            alpha: isDark ? 0.35 : 0.16,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.20 : 0.025,
            ),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? colors.primary.withValues(
                alpha: 0.18,
              )
                  : colors.primary.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.primary.withValues(
                  alpha: 0.28,
                ),
              ),
            ),
            child: Icon(
              Icons.insights_rounded,
              color: colors.primary,
              size: 23,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    color: isDark
                        ? Colors.white
                        : colors.onPrimaryContainer,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Started ${formatHabitStatsDate(startDate)}',
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: isDark
                        ? Colors.white.withValues(
                      alpha: 0.70,
                    )
                        : colors.onPrimaryContainer
                        .withValues(
                      alpha: 0.70,
                    ),
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
