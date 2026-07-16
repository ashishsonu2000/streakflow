import 'package:flutter/material.dart';

import '../animations/fade_slide.dart';
import '../design/app_breakpoints.dart';
import '../design/app_spacing.dart';

class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({
    super.key,
    required this.hero,
    required this.analytics,
    required this.habits,
    required this.calendar,
    required this.activity,
    required this.actions,
    required this.insights,
  });

  final Widget hero;
  final Widget analytics;
  final Widget habits;
  final Widget calendar;
  final Widget activity;
  final Widget actions;
  final Widget insights;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;

        if (width >= AppBreakpoints.desktop) {
          return _desktopLayout();
        }

        if (width >= AppBreakpoints.tablet) {
          return _tabletLayout();
        }

        return _mobileLayout();
      },
    );
  }

  //==========================================================
  // MOBILE
  //==========================================================

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlide(child: hero),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 100),
          child: analytics,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 200),
          child: habits,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 300),
          child: calendar,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 400),
          child: activity,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 500),
          child: insights,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 600),
          child: actions,
        ),
      ],
    );
  }

  //==========================================================
  // TABLET
  //==========================================================

  Widget _tabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlide(child: hero),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 100),
          child: analytics,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 200),
          child: habits,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 300),
                child: calendar,
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 350),
                child: activity,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 450),
                child: insights,
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 500),
                child: actions,
              ),
            ),
          ],
        ),
      ],
    );
  }

  //==========================================================
  // DESKTOP
  //==========================================================

  Widget _desktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlide(child: hero),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 100),
          child: analytics,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 200),
          child: habits,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 450),
                child: insights,
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 500),
                child: actions,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
