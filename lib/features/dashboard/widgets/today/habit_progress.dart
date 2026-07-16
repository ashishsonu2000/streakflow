import 'package:flutter/material.dart';

class HabitProgress extends StatelessWidget {
  const HabitProgress({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
      ),
    );
  }
}
