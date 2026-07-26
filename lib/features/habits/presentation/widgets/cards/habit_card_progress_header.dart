import 'package:flutter/material.dart';

class HabitCardProgressHeader extends StatelessWidget {
  const HabitCardProgressHeader({
    super.key,
    required this.label,
    required this.percent,
  });

  final String label;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Spacer(),
        Text(
          '$percent%',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
