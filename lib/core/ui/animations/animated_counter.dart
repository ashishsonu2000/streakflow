import 'package:flutter/material.dart';

class AnimatedCounter extends StatelessWidget {
  final int value;

  final TextStyle? style;

  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: value.toDouble(),
      ),
      duration: duration,
      curve: Curves.easeOut,
      builder: (_, value, __) {
        return Text(
          value.toInt().toString(),
          style: style,
        );
      },
    );
  }
}
