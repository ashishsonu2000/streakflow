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
    return AppCard(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: insight.color,
              width: 3,
            ),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 12,
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // =========================================================
            // ICON
            // =========================================================

            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: insight.color.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                insight.icon,
                size: 21,
                color: insight.color,
              ),
            ),

            const SizedBox(width: 14),

            // =========================================================
            // CONTENT
            // =========================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.title,
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w700,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    insight.message,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}