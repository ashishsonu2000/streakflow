import 'package:flutter/material.dart';




import '../../../domain/models/heatmap_day.dart';
import 'heatmap_cell.dart';

class HeatmapCalendar extends StatelessWidget {
  const HeatmapCalendar({
    super.key,
    required this.days,
  });

  final List<HeatmapDay> days;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children:
          days
              .map(
                (day) => Tooltip(
              message:
              '${day.date.day}/${day.date.month}\n${day.completions} completions',
              child: HeatmapCell(
                completions:
                day.completions,
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}