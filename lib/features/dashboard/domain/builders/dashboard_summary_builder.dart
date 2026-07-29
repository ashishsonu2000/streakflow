import 'package:flutter/material.dart';

import '../../../calendar/domain/models/calendar_view_model.dart';
import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/calculators/activity_calculator.dart';
import '../../../habits/domain/extensions/habit_category_extension.dart';
import '../../../habits/domain/models/habit.dart';

import '../models/dashboard_section.dart';
import '../models/dashboard_view_model.dart';
import '../models/hero_view_model.dart';
import '../models/quick_action_model.dart';
import '../models/today_habit_view_model.dart';
import '../models/user_summary.dart';

import '../services/dashboard_analytics_service.dart';
import '../services/dashboard_insight_generator.dart';
import '../services/hero_summary_calculator.dart';

class DashboardSummaryBuilder {
  DashboardSummaryBuilder({
    DashboardAnalyticsService? analyticsService,
    HeroSummaryCalculator? heroCalculator,
    DashboardInsightGenerator? insightGenerator,
  })  : _analyticsService = analyticsService ?? DashboardAnalyticsService(),
        _heroCalculator = heroCalculator ?? HeroSummaryCalculator(),
        _insightGenerator = insightGenerator ?? DashboardInsightGenerator();

  final DashboardAnalyticsService _analyticsService;
  final HeroSummaryCalculator _heroCalculator;
  final DashboardInsightGenerator _insightGenerator;

  Future<DashboardViewModel> build({
    required String userName,
    required List<Habit> habits,
    required List<HabitLogEntity> logs,
    required CalendarViewModel calendar,
  }) async {
    //------------------------------------------
    // Dashboard Analytics
    //------------------------------------------

    final analytics = _analyticsService.calculate(
      habits: habits,
      logs: logs,
      calendar: calendar,
    );

    //------------------------------------------
    // Hero Summary
    //------------------------------------------

    final heroSummary = _heroCalculator.calculate(
      analytics,
    );

    //------------------------------------------
    // Hero ViewModel
    //------------------------------------------

    final hero = HeroViewModel(
      currentStreak: heroSummary.currentStreak,
      bestStreak: heroSummary.bestStreak,
      totalXP: heroSummary.levelSummary.totalXp,
      level: heroSummary.levelSummary.level,
      completedToday: analytics.completedToday,
      totalToday: analytics.totalHabits,
      nextLevelXP: heroSummary.levelSummary.nextLevelXp,
      xpProgress: heroSummary.levelSummary.progress,
      target: analytics.totalHabits,
    );

    //------------------------------------------
    // Recent Activity
    //------------------------------------------

    final activities = ActivityCalculator.calculate(logs);

    //------------------------------------------
    // Insights
    //------------------------------------------

    final insights = _insightGenerator.generate(hero);

    //------------------------------------------
    // Today's Habits
    //------------------------------------------

    final todayHabits = habits.map((habit) {
      return TodayHabitViewModel(
        id: habit.id,
        title: habit.title,
        icon: IconData(
          habit.iconCodePoint,
          fontFamily: 'MaterialIcons',
        ),
        color: Color(habit.colorValue),
        completed: habit.completedToday,
        currentStreak: habit.currentStreak,
        durationMinutes: 15,
        target: habit.targetPerDay,
        category: habit.category.label,
        difficulty: 'Medium',
      );
    }).toList();

    //------------------------------------------
    // Dashboard Sections
    //------------------------------------------

    final sections = DashboardSections(
      todayHabits: todayHabits,
      activities: activities,
      actions: _defaultActions(),
      insights: insights,
      hasHabits: todayHabits.isNotEmpty,
      hasActivities: activities.isNotEmpty,
    );

    //------------------------------------------
    // Dashboard ViewModel
    //------------------------------------------

    return DashboardViewModel(
      user: UserSummary(
        greeting: _greeting(),
        userName: userName,
      ),
      hero: hero,
      analytics: analytics,
      sections: sections,
    );
  }

  //--------------------------------------------------
  // Quick Actions
  //--------------------------------------------------

  List<QuickActionModel> _defaultActions() {
    return const [
      QuickActionModel(
        title: 'Add Habit',
        icon: Icons.add_circle_outline,
        route: '/habit/form',
      ),
      QuickActionModel(
        title: 'Calendar',
        icon: Icons.calendar_month_outlined,
        route: '/calendar',
      ),
      QuickActionModel(
        title: 'Statistics',
        icon: Icons.bar_chart_rounded,
        route: '/statistics',
      ),
      QuickActionModel(
        title: 'Achievements',
        icon: Icons.emoji_events_outlined,
        route: '/achievements',
      ),
    ];
  }

  //--------------------------------------------------
  // Greeting
  //--------------------------------------------------

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    }

    if (hour < 17) {
      return 'Good Afternoon';
    }

    return 'Good Evening';
  }
}
