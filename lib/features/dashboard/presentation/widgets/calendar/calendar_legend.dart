import 'package:flutter/material.dart';

class CalendarLegend extends StatelessWidget {
  const CalendarLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: [
        const Icon(
          Icons.circle,
          size: 10,
          color: Colors.green,
        ),
        const SizedBox(width: 4),
        Text("Completed", style: style),
        const SizedBox(width: 20),
        const Icon(
          Icons.local_fire_department,
          size: 16,
          color: Colors.orange,
        ),
        const SizedBox(width: 4),
        Text("Today", style: style),
      ],
    );
  }
}
