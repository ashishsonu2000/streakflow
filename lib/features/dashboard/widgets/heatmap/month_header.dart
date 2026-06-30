import 'package:flutter/material.dart';

class MonthHeader extends StatelessWidget {
  final String month;

  const MonthHeader({
    super.key,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          month,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        Text(
          "Activity",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
