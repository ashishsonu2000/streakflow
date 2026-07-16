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
            Color(0xff5B5FEF),
            Color(0xff6C63FF),
            Color(0xff7B74FF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff5B5FEF).withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
