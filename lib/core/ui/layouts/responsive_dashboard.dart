import 'package:flutter/material.dart';

class ResponsiveDashboard extends StatelessWidget {
  final Widget hero;
  final Widget habits;
  final Widget actions;
  final Widget weekly;
  final Widget heatmap;
  final Widget activity;
  final Widget insights;

  const ResponsiveDashboard({
    super.key,
    required this.hero,
    required this.habits,
    required this.actions,
    required this.weekly,
    required this.heatmap,
    required this.activity,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= 1100) {
          return _desktopLayout();
        }

        if (width >= 700) {
          return _tabletLayout();
        }

        return _mobileLayout();
      },
    );
  }

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hero,
        const SizedBox(height: 24),
        habits,
        const SizedBox(height: 24),
        actions,
        const SizedBox(height: 24),
        weekly,
        const SizedBox(height: 24),
        heatmap,
        const SizedBox(height: 24),
        activity,
        const SizedBox(height: 24),
        insights,
      ],
    );
  }

  Widget _tabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hero,
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: habits,
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: actions,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: weekly,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: heatmap,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: activity,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: insights,
            ),
          ],
        ),
      ],
    );
  }

  Widget _desktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hero,
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: habits,
            ),
            const SizedBox(width: 32),
            Expanded(
              child: actions,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: weekly,
            ),
            const SizedBox(width: 32),
            Expanded(
              child: heatmap,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: activity,
            ),
            const SizedBox(width: 32),
            Expanded(
              child: insights,
            ),
          ],
        ),
      ],
    );
  }
}
