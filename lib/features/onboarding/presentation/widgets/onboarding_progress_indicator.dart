import 'package:flutter/material.dart';

import 'onboarding_theme.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  const OnboardingProgressIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final value = (currentPage + 1) / totalPages;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: SizedBox(
                height: 5,
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation(
                    OnboardingColors.navy,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${currentPage + 1}/$totalPages',
            style: const TextStyle(
              color: OnboardingColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
