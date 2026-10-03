import 'package:flutter/material.dart';
import 'dart:math';

class ParticleExplosion extends StatefulWidget {
  const ParticleExplosion({super.key});

  @override
  State<ParticleExplosion> createState() => _ParticleExplosionState();
}

class _ParticleExplosionState extends State<ParticleExplosion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Stack(
            children: List.generate(20, (index) {
              final angle = random.nextDouble() * 2 * pi;
              final distance = _controller.value * 120;

              return Positioned(
                left: MediaQuery.of(context).size.width / 2,
                top: MediaQuery.of(context).size.height / 2,
                child: Transform.translate(
                  offset: Offset(
                    cos(angle) * distance,
                    sin(angle) * distance,
                  ),
                  child: Opacity(
                    opacity: 1 - _controller.value,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}