import 'package:flutter/material.dart';

class HeroBackground extends StatelessWidget {
  const HeroBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        // =============================================================
        // PREMIUM GRADIENT
        // =============================================================

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [
            0.0,
            0.48,
            1.0,
          ],
          colors: [
            Color(0xFF5148E8),
            Color(0xFF6366F1),
            Color(0xFF7C3AED),
          ],
        ),

        // =============================================================
        // SOFT PREMIUM SHADOW
        // =============================================================

        boxShadow: [
          BoxShadow(
            color: Color(0x45514AE8),
            blurRadius: 30,
            spreadRadius: 0,
            offset: Offset(0, 14),
          ),
          BoxShadow(
            color: Color(0x1A6366F1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),

      // ===============================================================
      // BACKGROUND DECORATION
      // ===============================================================

      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // ---------------------------------------------------------
            // TOP LEFT LIGHT
            // ---------------------------------------------------------

            Positioned(
              top: -75,
              left: -65,
              child: IgnorePointer(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.white.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                      stops: const [
                        0.0,
                        0.55,
                        1.0,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------
            // BOTTOM RIGHT LIGHT
            // ---------------------------------------------------------

            Positioned(
              right: -85,
              bottom: -90,
              child: IgnorePointer(
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.09),
                        Colors.white.withValues(alpha: 0.025),
                        Colors.transparent,
                      ],
                      stops: const [
                        0.0,
                        0.55,
                        1.0,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------
            // SUBTLE TOP HIGHLIGHT
            // ---------------------------------------------------------

            Positioned(
              top: 0,
              left: 40,
              right: 40,
              child: IgnorePointer(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------
            // CONTENT
            // ---------------------------------------------------------

            child,
          ],
        ),
      ),
    );
  }
}