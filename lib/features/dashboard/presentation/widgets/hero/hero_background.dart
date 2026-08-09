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

        /// 🌈 Premium Gradient
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff5B5FEF),
            Color(0xff6C63FF),
            Color(0xff7B74FF),
          ],
        ),

        /// 💎 Soft Glow Shadow
        boxShadow: [
          BoxShadow(
            color: const Color(0xff5B5FEF).withOpacity(0.35),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),

      /// ✨ Glass overlay
      child: Stack(
        children: [
          /// Light reflection (premium touch)
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          child,
        ],
      ),
    );
  }
}