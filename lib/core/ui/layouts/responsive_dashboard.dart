import 'package:flutter/material.dart';

import '../animations/fade_slide.dart';
import '../design/app_breakpoints.dart';
import '../design/app_spacing.dart';

class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({
    super.key,
    required this.hero,
    required this.habits,
    required this.actions,
    required this.weekly,
    required this.heatmap,
    required this.activity,
    required this.insights,
    this.analytics,
  });

  final Widget hero;
  final Widget habits;
  final Widget actions;
  final Widget weekly;
  final Widget heatmap;
  final Widget activity;
  final Widget insights;

  /// Optional analytics section
  final Widget? analytics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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

  // ----------------------------------------------------------
  // MOBILE
  // ----------------------------------------------------------

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlide(
          delay: const Duration(milliseconds: 100),
          child: hero,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 200),
          child: habits,
        ),
        if (analytics != null) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          FadeSlide(
            delay: const Duration(milliseconds: 250),
            child: analytics!,
          ),
        ],
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 300),
          child: actions,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 400),
          child: weekly,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 500),
          child: heatmap,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 600),
          child: activity,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 700),
          child: insights,
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // TABLET
  // ----------------------------------------------------------

  Widget _tabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlide(
          child: hero,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 200),
          child: habits,
        ),
        if (analytics != null) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          FadeSlide(
            delay: const Duration(milliseconds: 250),
            child: analytics!,
          ),
        ],
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 300),
                child: actions,
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 400),
                child: weekly,
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
                delay: const Duration(milliseconds: 500),
                child: heatmap,
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 600),
                child: activity,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        FadeSlide(
          delay: const Duration(milliseconds: 700),
          child: insights,
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // DESKTOP
  // ----------------------------------------------------------

  Widget _desktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlide(
          child: hero,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: FadeSlide(
                delay: const Duration(milliseconds: 200),
                child: habits,
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 300),
                child: actions,
              ),
            ),
          ],
        ),
        if (analytics != null) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          FadeSlide(
            delay: const Duration(milliseconds: 350),
            child: analytics!,
          ),
        ],
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 400),
                child: weekly,
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 500),
                child: heatmap,
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
                delay: const Duration(milliseconds: 600),
                child: activity,
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: FadeSlide(
                delay: const Duration(milliseconds: 700),
                child: insights,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
