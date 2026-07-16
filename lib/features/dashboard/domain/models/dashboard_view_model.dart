import '../../../calendar/domain/models/calendar_view_model.dart';
import '../../../statistics/domain/models/daily_statistics.dart';

import 'activity_item.dart';
import 'analytics_card_model.dart';
import 'hero_view_model.dart';
import 'insight_item.dart';
import 'quick_action_model.dart';
import 'today_habit_view_model.dart';

class DashboardViewModel {
  const DashboardViewModel({
    required this.greeting,
    required this.userName,
    required this.hero,
    required this.todayHabits,
    required this.analytics,
    required this.calendar,
    required this.weekly,
    required this.activities,
    required this.actions,
    required this.insights,
    required this.hasHabits,
    required this.hasActivities,
  });

  final List<InsightItem> insights;
  final String greeting;

  final String userName;

  final HeroViewModel hero;

  final List<TodayHabitViewModel> todayHabits;

  final List<AnalyticsCardModel> analytics;

  final CalendarViewModel calendar;

  final List<DailyStatistics> weekly;

  final List<ActivityItem> activities;

  final List<QuickActionModel> actions;

  final bool hasHabits;

  final bool hasActivities;
}
