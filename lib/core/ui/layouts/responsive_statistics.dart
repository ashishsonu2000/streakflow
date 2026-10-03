import 'package:flutter/material.dart';

import '../design/app_breakpoints.dart';
import '../design/app_spacing.dart';

class ResponsiveStatistics extends StatelessWidget {
  const ResponsiveStatistics({
    super.key,
    required this.overview,
    required this.weekly,
    required this.monthly,
    required this.performance,
    required this.insights,
  });

  final Widget overview;
  final Widget weekly;
  final Widget monthly;
  final Widget performance;
  final Widget insights;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        //------------------------------------------
        // Phone
        //------------------------------------------

        if (constraints.maxWidth < AppBreakpoints.tablet) {
          return Column(
            children: [
              overview,
              const SizedBox(height: AppSpacing.sectionSpacing),
              weekly,
              const SizedBox(height: AppSpacing.sectionSpacing),
              monthly,
              const SizedBox(height: AppSpacing.sectionSpacing),
              performance,
              const SizedBox(height: AppSpacing.sectionSpacing),
              insights,
            ],
          );
        }

        //------------------------------------------
        // Tablet/Desktop
        //------------------------------------------

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: overview),
                const SizedBox(width: AppSpacing.sectionSpacing),
                Expanded(child: weekly),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: monthly),
                const SizedBox(width: AppSpacing.sectionSpacing),
                Expanded(child: performance),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionSpacing),
            insights,
          ],
        );
      },
    );
  }
}
