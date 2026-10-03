import 'package:flutter/material.dart';

class HeatmapLegend extends StatelessWidget {
  const HeatmapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    Widget box(Color color) {
      return Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      );
    }

    return Row(
      children: [
        const Text("Less"),
        const SizedBox(width: 8),
        box(Colors.grey.shade300),
        const SizedBox(width: 4),
        box(Colors.green.shade100),
        const SizedBox(width: 4),
        box(Colors.green.shade300),
        const SizedBox(width: 4),
        box(Colors.green.shade500),
        const SizedBox(width: 4),
        box(Colors.green.shade700),
        const SizedBox(width: 8),
        const Text("More"),
      ],
    );
  }
}
