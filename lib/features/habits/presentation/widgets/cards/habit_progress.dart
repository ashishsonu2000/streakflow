import 'package:flutter/material.dart';

class HabitProgress extends StatelessWidget {
  const HabitProgress({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress.clamp(0, 1),
        minHeight: 8,
      ),
    );
  }
}
