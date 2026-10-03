import 'dart:math' as math;

import 'package:flutter/material.dart';

class FireStreak extends StatefulWidget {
  const FireStreak({
    super.key,
    this.size = 38,
  });

  final double size;

  @override
  State<FireStreak> createState() => _FireStreakState();
}

class _FireStreakState extends State<FireStreak>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Smooth pulse between 0 and 1.
        final pulse =
            (math.sin(_controller.value * math.pi * 2) + 1) / 2;

        final scale = 0.96 + (pulse * 0.06);
        final glow = 6.0 + (pulse * 6.0);

        return SizedBox(
          width: widget.size + 28,
          height: widget.size + 28,
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: widget.size + 12,
                height: widget.size + 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.withValues(
                    alpha: 0.04 + (pulse * 0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(
                        alpha: 0.18 + (pulse * 0.18),
                      ),
                      blurRadius: glow,
                      spreadRadius: pulse * 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.orange,
                    size: widget.size,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}