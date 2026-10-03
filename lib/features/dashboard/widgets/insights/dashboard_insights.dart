import 'package:flutter/material.dart';

import '../../../../core/ui/insights/insight_item.dart';
import '../../../../core/ui/section/app_section_header.dart';

import 'insight_card.dart';

class DashboardInsights extends StatelessWidget {
  const DashboardInsights({
    super.key,
    required this.insights,
  });

  final List<InsightItem> insights;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // =========================================================
        // SECTION HEADER
        // =========================================================

        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? colors.primaryContainer.withValues(
                  alpha: 0.65,
                )
                    : const Color(0xFFEFF6FF),
                borderRadius:
                BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? colors.primary.withValues(
                    alpha: 0.25,
                  )
                      : const Color(0xFF2563EB)
                      .withValues(
                    alpha: 0.08,
                  ),
                ),
              ),
              child: Icon(
                Icons.lightbulb_rounded,
                size: 21,
                color: isDark
                    ? colors.primary
                    : const Color(0xFF2563EB),
              ),
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: AppSectionHeader(
                title: 'Insights',
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // =========================================================
        // INSIGHTS
        // =========================================================

        ListView.separated(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),

          itemCount: insights.length,

          separatorBuilder: (_, __) {
            return const SizedBox(
              height: 10,
            );
          },

          itemBuilder: (context, index) {
            final insight = insights[index];

            return InsightCard(
              icon: insight.icon,
              color: insight.color,
              title: insight.title,
              message: insight.message,
            );
          },
        ),
      ],
    );
  }
}