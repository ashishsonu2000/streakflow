import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/design/app_breakpoints.dart';
import '../../../../core/ui/design/app_spacing.dart';
import '../../../../core/ui/layouts/responsive_dashboard.dart';

import '../../../core/ui/dashboard/dashboard_header.dart';
import '../../../shell/presentation/provider/navigation_provider.dart';
import '../../calendar/presentation/providers/calendar_provider.dart';
import '../domain/models/dashboard_view_model.dart';

import '../presentation/widgets/actions/quick_actions.dart';
import '../presentation/widgets/activity/recent_activity.dart';
import '../presentation/widgets/analytics/analytics_grid.dart';
import '../presentation/widgets/calendar/mini_calendar.dart';

import '../presentation/widgets/hero/hero_card.dart';
import '../presentation/widgets/today/today_habits_section.dart';
import '../presentation/widgets/weekly/dashboard_weekly_progress_card.dart';

import 'insights/dashboard_insights.dart';

class DashboardBody extends ConsumerWidget {
  const DashboardBody({
    super.key,
    required this.dashboard,
  });

  final DashboardViewModel dashboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = dashboard.sections;

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
          child: ResponsiveDashboard(
            header: DashboardHeader(
              greeting: dashboard.user.greeting,
              userName: dashboard.user.userName,
            ),
            hero: HeroCard(
              hero: dashboard.hero,
            ),
            analytics: AnalyticsGrid(
              analytics: dashboard.analyticsCards,
            ),
            habits: TodayHabitsSection(
              habits: sections.todayHabits,
            ),
            calendar: MiniCalendar(
              calendar: dashboard.calendar,
              onTap: (date) async {
                await ref.read(calendarProvider.notifier).openDate(date);
                ref.read(navigationProvider.notifier).goCalendar();
              },
            ),
            weekly: DashboardWeeklyProgressCard(
              weekly: sections.weeklyProgress,
            ),
            activity: RecentActivity(
              activities: sections.activities,
            ),
            insights: DashboardInsights(
              insights: sections.insights,
            ),
            actions: QuickActions(
              actions: sections.actions,
              onActionTap: (action) {
                debugPrint(action.title);
              },
            ),
          ),
        ),
      ),
    );
  }
}