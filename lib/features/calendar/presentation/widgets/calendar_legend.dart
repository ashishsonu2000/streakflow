import 'package:flutter/material.dart';

class CalendarLegend extends StatelessWidget {
  const CalendarLegend({
    super.key,
  });

  Widget _item(
    BuildContext context,
    Color color,
    String text,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _item(
            context,
            Colors.grey.shade300,
            "None",
          ),
          _item(
            context,
            Colors.green.shade100,
            "Low",
          ),
          _item(
            context,
            Colors.green.shade300,
            "Medium",
          ),
          _item(
            context,
            Colors.green.shade500,
            "High",
          ),
          _item(
            context,
            Colors.green.shade700,
            "Perfect",
          ),
        ],
      ),
    );
  }
}
