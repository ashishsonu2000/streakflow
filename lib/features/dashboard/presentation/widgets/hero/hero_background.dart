import 'package:flutter/material.dart';

class HeroBackground extends StatelessWidget {
  const HeroBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        // ===========================================================
        // HERO GRADIENT
        // ===========================================================

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
            Color(0xFF08132F),
            Color(0xFF102557),
            Color(0xFF193F9C),
          ]
              : const [
            Color(0xFF1A2C68),
            Color(0xFF23439B),
            Color(0xFF2855C7),
          ],
        ),

        // ===========================================================
        // HERO BORDER
        // ===========================================================

        border: Border.all(
          color: isDark
              ? const Color(0xFF315BB5).withValues(
            alpha: 0.55,
          )
              : const Color(0xFF3B82F6).withValues(
            alpha: 0.30,
          ),
          width: 1,
        ),

        // ===========================================================
        // SHADOW
        // ===========================================================

        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF000000).withValues(
              alpha: 0.40,
            )
                : const Color(0xFF172554).withValues(
              alpha: 0.20,
            ),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // =======================================================
            // TOP-RIGHT DECORATIVE CIRCLE
            // =======================================================

            Positioned(
              top: -70,
              right: -55,
              child: Container(
                width: 185,
                height: 185,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(
                    alpha: isDark ? 0.045 : 0.07,
                  ),
                ),
              ),
            ),

            // =======================================================
            // BOTTOM-LEFT DECORATIVE CIRCLE
            // =======================================================

            Positioned(
              bottom: -95,
              left: -65,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(
                    alpha: isDark ? 0.025 : 0.045,
                  ),
                ),
              ),
            ),

            // =======================================================
            // SUBTLE CENTER GLOW
            // =======================================================

            Positioned(
              top: 95,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.75,
                      colors: [
                        const Color(0xFF3B82F6)
                            .withValues(
                          alpha: isDark ? 0.10 : 0.08,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // =======================================================
            // CONTENT
            // =======================================================

            child,
          ],
        ),
      ),
    );
  }
}