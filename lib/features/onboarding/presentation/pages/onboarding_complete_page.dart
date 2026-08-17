import 'package:flutter/material.dart';

class OnboardingCompletePage extends StatelessWidget {
  const OnboardingCompletePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.celebration_outlined,
          size: 96,
        ),
        SizedBox(height: 32),
        Text(
          "You're all set!",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Let's start building your streak.",
        ),
      ],
    );
  }
}