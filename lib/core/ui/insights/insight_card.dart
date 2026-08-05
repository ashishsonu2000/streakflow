import 'package:flutter/material.dart';

import '../cards/app_card.dart';
import 'insight_item.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.insight,
  });

  final InsightItem insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //--------------------------------------------------
          // Icon
          //--------------------------------------------------

          CircleAvatar(
            radius: 22,
            backgroundColor: insight.color.withValues(
              alpha: .12,
            ),
            child: Icon(
              insight.icon,
              color: insight.color,
            ),
          ),

          const SizedBox(width: 16),

          //--------------------------------------------------
          // Text
          //--------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  insight.message,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
