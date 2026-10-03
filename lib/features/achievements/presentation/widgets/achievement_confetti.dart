import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class AchievementConfetti
    extends StatefulWidget {
  const AchievementConfetti({
    super.key,
  });

  @override
  State<AchievementConfetti>
  createState() {
    return _AchievementConfettiState();
  }
}

class _AchievementConfettiState
    extends State<AchievementConfetti> {
  late final ConfettiController
  _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        ConfettiController(
          duration:
          const Duration(
            seconds: 3,
          ),
        );

    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return ConfettiWidget(
      confettiController:
      _controller,
    );
  }
}