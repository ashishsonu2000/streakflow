import 'package:flutter/material.dart';

import '../sections/section_title.dart';
import 'heatmap_cell.dart';
import 'month_header.dart';

class MonthlyHeatmap extends StatelessWidget {
  const MonthlyHeatmap({super.key});

  static const List<int> sample = [
    3,
    2,
    1,
    0,
    2,
    3,
    3,
    3,
    3,
    2,
    1,
    2,
    0,
    3,
    2,
    3,
    3,
    3,
    1,
    2,
    3,
    0,
    2,
    3,
    3,
    3,
    2,
    1,
    2,
    3
  ];

  @override
  Widget build(BuildContext context) {
    final active = sample.where((e) => e > 0).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: "Monthly Activity",
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const MonthHeader(
                  month: "June",
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sample.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemBuilder: (_, index) {
                    return HeatmapCell(
                      intensity: sample[index],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "$active / ${sample.length} Active Days",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
