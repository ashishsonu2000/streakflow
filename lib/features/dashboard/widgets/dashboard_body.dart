import 'package:flutter/material.dart';

import '../../../core/ui/animations/fade_slide.dart';
import '../../../core/ui/cards/hero_card.dart';
import '../../../core/ui/design/app_breakpoints.dart';
import '../../../core/ui/design/app_spacing.dart';
import '../../../core/ui/layouts/responsive_dashboard.dart';

import '../domain/models/dashboard_summary.dart';

import 'actions/quick_actions.dart';
import 'activity/recent_activity.dart';
import 'heatmap/monthly_heatmap.dart';
import 'insights/dashboard_insights.dart';
import 'sections/dashboard_header.dart';
import 'sections/today_habits.dart';
import 'sections/today_habits_container.dart';
import 'weekly/weekly_progress_section.dart';

class DashboardBody extends StatelessWidget {
  final DashboardSummary dashboard;

  const DashboardBody({
    super.key,
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.pagePadding,
        AppSpacing.pagePadding,
        100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.largeDesktop,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlide(
                child: DashboardHeader(
                  greeting: dashboard.greeting,
                  name: dashboard.userName,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              ResponsiveDashboard(
                hero: HeroCard(
                  streak: dashboard.streak,
                ),
                habits: const TodayHabitsContainer(),
                actions: QuickActions(
                  actions: dashboard.actions,
                ),
                weekly: WeeklyProgressSection(
                  weekly: dashboard.weekly,
                ),
                heatmap: const MonthlyHeatmap(),
                activity: RecentActivity(
                  activities: dashboard.recentActivity,
                ),
                insights: const DashboardInsights(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
