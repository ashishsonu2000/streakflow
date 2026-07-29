import 'package:flutter/material.dart';

import '../../../../core/ui/animations/animated_counter.dart';

class HeroCounter extends StatelessWidget {
  final int streak;

  const HeroCounter({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCounter(
          value: streak,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Text(
          "DAY STREAK",
          style: TextStyle(
            color: Colors.white70,
            letterSpacing: 2,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
