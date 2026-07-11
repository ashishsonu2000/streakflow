import 'package:flutter/material.dart';

class AnimatedValueText extends StatelessWidget {
  const AnimatedValueText({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 700),
    this.style,
    this.prefix = "",
    this.suffix = "",
  });

  final int value;

  final Duration duration;

  final TextStyle? style;

  final String prefix;

  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(
        begin: 0,
        end: value,
      ),
      duration: duration,
      builder: (context, value, child) {
        return Text(
          "$prefix$value$suffix",
          style: style,
        );
      },
    );
  }
}
