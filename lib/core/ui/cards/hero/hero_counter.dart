import 'package:flutter/material.dart';

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
        Text(
          streak.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 72,
            fontWeight: FontWeight.bold,
            height: 1,
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
