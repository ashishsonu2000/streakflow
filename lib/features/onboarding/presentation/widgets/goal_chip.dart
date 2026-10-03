import 'package:flutter/material.dart';

import 'onboarding_theme.dart';

class GoalChip extends StatelessWidget {
  const GoalChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      OnboardingColors.navy,
                      OnboardingColors.navyLight,
                    ],
                  )
                : const LinearGradient(
                    colors: [Colors.white, Color(0xFFF8FAFC)],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? OnboardingColors.navy
                  : OnboardingColors.border,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x2414213D),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  selected ? Icons.check_rounded : Icons.add_rounded,
                  key: ValueKey(selected),
                  size: 17,
                  color: selected ? Colors.white : OnboardingColors.muted,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : OnboardingColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
