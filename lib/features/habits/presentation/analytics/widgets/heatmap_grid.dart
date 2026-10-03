import 'package:flutter/material.dart';



import '../../../domain/models/analytics/heatmap_day.dart';
import 'heatmap_cell.dart';

class HeatmapGrid extends StatelessWidget {
  const HeatmapGrid({
    super.key,
    required this.days,
    this.onDayTap,
  });

  final List<HeatmapDay> days;

  final ValueChanged<HeatmapDay>? onDayTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: days.map((day) {
        return HeatmapCell(
          intensity: day.count,
          onTap: () {
            onDayTap?.call(day);
          },
        );
      }).toList(),
    );
  }
}
