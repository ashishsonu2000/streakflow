import 'package:flutter/material.dart';

import '../widgets/onboarding_theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/branding/app_icon.png',
              width: 104,
              height: 104,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const OnboardingTitle(
              title: 'Welcome to\nStreak Flow',
              subtitle: 'Build better habits. Stay consistent.\nTrack your progress.',
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: const [
                _MiniPill(icon: Icons.trending_up_rounded, label: 'Progress'),
                _MiniPill(icon: Icons.local_fire_department_outlined, label: 'Streaks'),
                _MiniPill(icon: Icons.emoji_events_outlined, label: 'Goals'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xE6FFFFFF),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: OnboardingColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, size: 15, color: OnboardingColors.navy),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: OnboardingColors.text, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
