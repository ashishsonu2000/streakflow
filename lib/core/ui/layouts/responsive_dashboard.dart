import 'package:flutter/material.dart';

import '../animations/fade_slide.dart';
import '../design/app_breakpoints.dart';

class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({
    super.key,
    required this.header,
    required this.hero,
    required this.analytics,
    required this.habits,
    required this.calendar,
    required this.weekly,
    required this.activity,
    required this.insights,
    required this.recovery,
  });

  final Widget header;
  final Widget hero;
  final Widget analytics;
  final Widget habits;
  final Widget calendar;
  final Widget weekly;
  final Widget activity;
  final Widget insights;
  final Widget recovery;

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

  // ==============================================================
  // MOBILE
  // ==============================================================

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ==========================================================
        // HEADER
        //
        // DashboardBody currently passes SizedBox.shrink()
        // because HeroCard contains the greeting.
        //
        // Keeping this here allows the component to remain reusable.
        // ==========================================================

        if (_hasVisibleWidget(header)) ...[
          header,
          const SizedBox(height: 14),
        ],

        // ==========================================================
        // HERO
        // ==========================================================

        hero,

        const SizedBox(height: 16),

        // ==========================================================
        // ANALYTICS
        // ==========================================================

        analytics,

        const SizedBox(height: 18),

        // ==========================================================
        // TODAY'S HABITS
        // ==========================================================

        habits,

        const SizedBox(height: 18),

        // ==========================================================
        // CALENDAR
        // ==========================================================

        calendar,

        const SizedBox(height: 18),

        // ==========================================================
        // WEEKLY PROGRESS
        // ==========================================================

        weekly,

        const SizedBox(height: 18),

        // ==========================================================
        // RECENT ACTIVITY
        // ==========================================================

        activity,

        const SizedBox(height: 18),

        // ==========================================================
        // INSIGHTS
        // ==========================================================

        insights,

        // ==========================================================
        // RECOVERY
        // ==========================================================

        if (_hasVisibleWidget(recovery)) ...[
          const SizedBox(height: 18),
          recovery,
        ],
      ],
    );
  }

  // ==============================================================
  // TABLET
  // ==============================================================

  Widget _tabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================================
        // HEADER
        // ==========================================================

        if (_hasVisibleWidget(header)) ...[
          FadeSlide(
            child: header,
          ),
          const SizedBox(height: 20),
        ],

        // ==========================================================
        // HERO
        // ==========================================================

        FadeSlide(
          child: hero,
        ),

        const SizedBox(height: 20),

        // ==========================================================
        // ANALYTICS
        // ==========================================================

        FadeSlide(
          delay: const Duration(
            milliseconds: 100,
          ),
          child: analytics,
        ),

        const SizedBox(height: 20),

        // ==========================================================
        // TODAY'S HABITS
        // ==========================================================

        FadeSlide(
          delay: const Duration(
            milliseconds: 200,
          ),
          child: habits,
        ),

        const SizedBox(height: 20),

        // ==========================================================
        // CALENDAR + WEEKLY
        // ==========================================================

        Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeSlide(
                delay: const Duration(
                  milliseconds: 300,
                ),
                child: calendar,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: FadeSlide(
                delay: const Duration(
                  milliseconds: 350,
                ),
                child: weekly,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ==========================================================
        // ACTIVITY + INSIGHTS
        // ==========================================================

        Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeSlide(
                delay: const Duration(
                  milliseconds: 400,
                ),
                child: activity,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: FadeSlide(
                delay: const Duration(
                  milliseconds: 450,
                ),
                child: insights,
              ),
            ),
          ],
        ),

        // ==========================================================
        // RECOVERY
        // ==========================================================

        if (_hasVisibleWidget(recovery)) ...[
          const SizedBox(height: 20),

          FadeSlide(
            delay: const Duration(
              milliseconds: 500,
            ),
            child: recovery,
          ),
        ],
      ],
    );
  }

  // ==============================================================
  // DESKTOP
  // ==============================================================

  Widget _desktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================================
        // HEADER
        // ==========================================================

        if (_hasVisibleWidget(header)) ...[
          FadeSlide(
            child: header,
          ),
          const SizedBox(height: 24),
        ],

        // ==========================================================
        // HERO
        // ==============================================================

        FadeSlide(
          child: hero,
        ),

        const SizedBox(height: 22),

        // ==========================================================
        // ANALYTICS
        // ==========================================================

        FadeSlide(
          delay: const Duration(
            milliseconds: 100,
          ),
          child: analytics,
        ),

        const SizedBox(height: 22),

        // ==========================================================
        // TODAY'S HABITS
        // ==========================================================

        FadeSlide(
          delay: const Duration(
            milliseconds: 200,
          ),
          child: habits,
        ),

        const SizedBox(height: 22),

        // ==========================================================
        // CALENDAR + WEEKLY
        // ==========================================================

        Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeSlide(
                delay: const Duration(
                  milliseconds: 300,
                ),
                child: calendar,
              ),
            ),

            const SizedBox(width: 22),

            Expanded(
              child: FadeSlide(
                delay: const Duration(
                  milliseconds: 350,
                ),
                child: weekly,
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // ==========================================================
        // ACTIVITY + INSIGHTS
        // ==========================================================

        Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeSlide(
                delay: const Duration(
                  milliseconds: 400,
                ),
                child: activity,
              ),
            ),

            const SizedBox(width: 22),

            Expanded(
              child: FadeSlide(
                delay: const Duration(
                  milliseconds: 450,
                ),
                child: insights,
              ),
            ),
          ],
        ),

        // ==========================================================
        // RECOVERY
        // ==========================================================

        if (_hasVisibleWidget(recovery)) ...[
          const SizedBox(height: 22),

          FadeSlide(
            delay: const Duration(
              milliseconds: 500,
            ),
            child: recovery,
          ),
        ],
      ],
    );
  }

  // ==============================================================
  // VISIBLE WIDGET CHECK
  // ==============================================================

  bool _hasVisibleWidget(Widget widget) {
    if (widget is SizedBox) {
      return widget.width != 0 ||
          widget.height != 0 ||
          widget.child != null;
    }

    return true;
  }
}