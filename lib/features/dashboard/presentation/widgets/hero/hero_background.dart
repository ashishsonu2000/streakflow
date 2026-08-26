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

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF172554),
            Color(0xFF1D4ED8),
          ],
          stops: [
            0.0,
            0.55,
            1.0,
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8)
                .withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // =====================================================
            // DECORATIVE GLOW
            // =====================================================

            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(
                    alpha: 0.06,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -70,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF60A5FA)
                      .withValues(alpha: 0.08),
                ),
              ),
            ),

            // =====================================================
            // CONTENT
            // =====================================================

            child,
          ],
        ),
      ),
    );
  }
}