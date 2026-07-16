import 'package:flutter/material.dart';

import '../../../../core/ui/animations/fade_slide.dart';
import '../../../../core/ui/design/app_breakpoints.dart';
import '../../../../core/ui/design/app_spacing.dart';
import '../../../../core/ui/layouts/responsive_dashboard.dart';

import '../domain/models/dashboard_view_model.dart';

import '../presentation/widgets/actions/quick_actions.dart';
import '../presentation/widgets/analytics/analytics_grid.dart';
import '../presentation/widgets/calendar/mini_calendar.dart';
import '../presentation/widgets/hero/hero_card.dart';

import '../presentation/widgets/today/today_habits_section.dart';

import 'activity/recent_activity.dart';
import 'insights/dashboard_insights.dart';
import 'sections/dashboard_header.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
    required this.dashboard,
  });

  final DashboardViewModel dashboard;

  @override
  Widget build(BuildContext context) {
    debugPrint(
      "Dashboard Insights: ${dashboard.insights.length}",
    );

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
                  userName: dashboard.userName,
                ),
              ),
              const SizedBox(
                height: AppSpacing.sectionGap,
              ),
              ResponsiveDashboard(
                hero: HeroCard(
                  hero: dashboard.hero,
                ),
                habits: TodayHabitsSection(
                  habits: dashboard.todayHabits,
                ),
                analytics: AnalyticsGrid(
                  analytics: dashboard.analytics,
                ),
                calendar: MiniCalendar(
                  calendar: dashboard.calendar,
                  onTap: () {
                    debugPrint("Calendar");
                  },
                ),
                activity: RecentActivity(
                  activities: dashboard.activities,
                ),
                insights: DashboardInsights(
                  insights: dashboard.insights,
                ),
                actions: QuickActions(
                  actions: dashboard.actions,
                  onActionTap: (action) {
                    debugPrint(action.title);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
