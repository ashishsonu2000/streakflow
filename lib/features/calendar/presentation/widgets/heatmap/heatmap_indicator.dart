import 'package:flutter/material.dart';

class HeatmapIndicator extends StatelessWidget {
  const HeatmapIndicator({
    super.key,
    required this.intensity,
    this.size = 8,
  });

  final int intensity;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final color = switch (intensity) {
      4 => scheme.primary,
      3 => scheme.primary.withValues(
        alpha: 0.65,
      ),
      2 => scheme.primary.withValues(
        alpha: 0.40,
      ),
      1 => scheme.primary.withValues(
        alpha: 0.20,
      ),
      _ => scheme.surfaceContainerHighest,
    };

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}