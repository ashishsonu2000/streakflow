import 'package:flutter/material.dart';

class OnboardingProgressIndicator
    extends StatelessWidget {
  const OnboardingProgressIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;

  final int totalPages;

  @override
  Widget build(
      BuildContext context,
      ) {
    return LinearProgressIndicator(
      value:
      (currentPage + 1) /
          totalPages,
    );
  }
}