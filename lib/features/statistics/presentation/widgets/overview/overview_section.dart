import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_card.dart';
import '../../../../../../core/ui/analytics/analytics_grid.dart';
import '../../../../../../core/ui/section/app_section_header.dart';

import '../../../data/mapper/overview_mapper.dart';
import '../../../domain/models/overview_statistics.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({
    super.key,
    required this.overview,
  });

  final OverviewStatistics overview;

  @override
  Widget build(BuildContext context) {
    final analytics = const OverviewMapper().map(
      overview,
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            title: 'Overview',
          ),
          const SizedBox(height: 20),
          AnalyticsGrid(
            analytics: analytics,
          ),
        ],
      ),
    );
  }
}
