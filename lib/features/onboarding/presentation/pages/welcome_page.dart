import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.emoji_events_outlined,
          size: 96,
        ),
        SizedBox(height: 32),
        Text(
          'Welcome to\nStreak Calculator',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Build better habits.\nStay consistent.\nTrack your progress.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}