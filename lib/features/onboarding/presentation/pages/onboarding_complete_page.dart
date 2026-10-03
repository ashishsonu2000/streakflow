import 'package:flutter/material.dart';

import '../widgets/onboarding_theme.dart';

class OnboardingCompletePage extends StatelessWidget {
  const OnboardingCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [OnboardingColors.navy, OnboardingColors.indigo],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2E14213D),
                    blurRadius: 28,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 58,
              ),
            ),
            const SizedBox(height: 30),
            const OnboardingTitle(
              title: "You're all set!",
              subtitle: "Let's start building your streak.\nSmall steps. Consistent progress.",
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xE6FFFFFF),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: OnboardingColors.border),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_fire_department_rounded, size: 17, color: OnboardingColors.navy),
                  SizedBox(width: 7),
                  Text(
                    'Your streak journey starts now',
                    style: TextStyle(color: OnboardingColors.text, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
