import 'package:flutter/material.dart';

/// Visual language shared by all onboarding screens.
class OnboardingColors {
  static const navy = Color(0xFF14213D);
  static const navyLight = Color(0xFF243B64);
  static const indigo = Color(0xFF6366F1);
  static const page = Color(0xFFF5F8FC);
  static const surface = Colors.white;
  static const text = Color(0xFF14213D);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const selected = Color(0xFFE9E7FF);
}

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFF5F8FC),
            Color(0xFFEEF3F9),
          ],
        ),
      ),
      child: child,
    );
  }
}

class OnboardingIconBadge extends StatelessWidget {
  const OnboardingIconBadge({
    super.key,
    required this.icon,
    this.size = 92,
  });

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            OnboardingColors.navy,
            OnboardingColors.navyLight,
          ],
        ),
        borderRadius: BorderRadius.circular(size * .30),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            offset: Offset(0, 12),
            color: Color(0x2414213D),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: size * .48,
        color: Colors.white,
      ),
    );
  }
}

class OnboardingTitle extends StatelessWidget {
  const OnboardingTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.center = true,
  });

  final String title;
  final String? subtitle;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: OnboardingColors.text,
            fontSize: 30,
            height: 1.16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.7,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            textAlign: center ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              color: OnboardingColors.muted,
              fontSize: 15,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

class OnboardingCard extends StatelessWidget {
  const OnboardingCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xF0FFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: OnboardingColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F14213D),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
