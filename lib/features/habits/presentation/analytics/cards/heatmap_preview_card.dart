import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_card.dart';
import '../../../domain/models/heatmap_day.dart';
import '../widgets/heatmap_grid.dart';
import '../widgets/heatmap_legend.dart';

class HeatmapPreviewCard extends StatelessWidget {
  const HeatmapPreviewCard({
    super.key,
    required this.days,
    this.onDayTap,
  });

  final List<HeatmapDay> days;

  final ValueChanged<HeatmapDay>? onDayTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final previewDays =
        days.length > 84 ? days.sublist(days.length - 84) : days;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Activity Heatmap",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          HeatmapGrid(
            days: previewDays,
            onDayTap: onDayTap,
          ),
          const SizedBox(height: 20),
          const HeatmapLegend(),
        ],
      ),
    );
  }
}
