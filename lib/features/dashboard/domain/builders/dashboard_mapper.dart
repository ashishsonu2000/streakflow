import 'package:flutter/material.dart';

import '../../../calendar/domain/models/calendar_view_model.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../statistics/data/mapper/overview_mapper.dart';
import '../../../statistics/domain/models/statistics_summary.dart';

import '../mappers/today_habit_mapper.dart';
import '../mappers/weekly_progress_mapper.dart';
import '../models/dashboard_section.dart';
import '../models/dashboard_view_model.dart';
import '../models/hero_view_model.dart';
import '../models/quick_action_model.dart';
import '../models/user_summary.dart';
import '../services/dashboard_insight_generator.dart';

class DashboardMapper {
  DashboardMapper({
    DashboardInsightGenerator? insightGenerator,
  }) : _insightGenerator =
            insightGenerator ?? const DashboardInsightGenerator();

  final DashboardInsightGenerator _insightGenerator;

  DashboardViewModel map(
    StatisticsSummary statistics, {
    required List<Habit> habits,
    required CalendarViewModel calendar,
    String userName = 'Ashish',
  }) {
    //------------------------------------------
    // Active Habits
    //------------------------------------------

    final activeHabits =
        habits.where((habit) => !habit.archived).toList(growable: false);

    final completedToday =
        activeHabits.where((habit) => habit.completedToday).length;

    //------------------------------------------
    // Hero
    //------------------------------------------

    final hero = HeroViewModel(
      currentStreak: statistics.overview.currentStreak,
      bestStreak: statistics.overview.bestStreak,
      totalXP: statistics.overview.totalXP,
      level: _calculateLevel(
        statistics.overview.totalXP,
      ),
      completedToday: completedToday,
      totalToday: activeHabits.length,
      nextLevelXP: _nextLevelXP(
        statistics.overview.totalXP,
      ),
      xpProgress: _xpProgress(
        statistics.overview.totalXP,
      ),
      target: activeHabits.length,
    );

    //------------------------------------------
    // Analytics
    //------------------------------------------

    final analyticsCards = const OverviewMapper().map(
      statistics.overview,
    );

    //------------------------------------------
    // Dashboard Sections
    //------------------------------------------

    final todayHabits = const TodayHabitMapper().map(
      activeHabits,
    );

    final sections = DashboardSections(
      todayHabits: todayHabits,
      activities: const [],
      actions: _defaultActions(),
      insights: _insightGenerator.generate(
        hero,
      ),
      weeklyProgress: const WeeklyProgressMapper().map(
        statistics.weekly,
      ),
      hasHabits: todayHabits.isNotEmpty,
      hasActivities: false,
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
      analyticsCards: analyticsCards,
      calendar: calendar,
      sections: sections,
    );
  }

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

  int _calculateLevel(int xp) {
    return (xp ~/ 100) + 1;
  }

  int _nextLevelXP(int xp) {
    final level = _calculateLevel(xp);
    return level * 100;
  }

  double _xpProgress(int xp) {
    return (xp % 100) / 100.0;
  }
}
