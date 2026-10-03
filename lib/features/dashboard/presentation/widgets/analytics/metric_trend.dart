import 'package:flutter/material.dart';

class MetricTrend extends StatelessWidget {
  const MetricTrend({
    super.key,
    required this.text,
    this.positive = true,
  });

  final String text;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? Colors.green : Colors.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          positive ? Icons.trending_up : Icons.trending_down,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
