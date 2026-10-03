import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_card.dart';
import '../../../../../../core/ui/insights/insights_list.dart';
import '../../../../../../core/ui/section/app_section_header.dart';

import '../../../data/mapper/insight_mapper.dart';
import '../../../domain/models/insight.dart';

class InsightsSection extends StatelessWidget {
  const InsightsSection({
    super.key,
    required this.insights,
  });

  final List<Insight> insights;

  @override
  Widget build(BuildContext context) {
    final items = const InsightMapper().map(
      insights,
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            title: 'Insights',
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 32,
              ),
              child: Center(
                child: Text(
                  'No insights available.',
                ),
              ),
            )
          else
            InsightsList(
              insights: items,
            ),
        ],
      ),
    );
  }
}
