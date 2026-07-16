import 'package:flutter/material.dart';

import '../../../calendar/domain/models/calendar_view_model.dart';
import '../../../habits/domain/extensions/habit_category_extension.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../statistics/domain/models/daily_statistics.dart';

import '../models/activity_item.dart';
import '../models/activity_status.dart';
import '../models/analytics_card_model.dart';
import '../models/dashboard_metric_type.dart';
import '../models/dashboard_view_model.dart';
import '../models/hero_view_model.dart';
import '../models/quick_action_model.dart';
import '../models/today_habit_view_model.dart';
import '../services/ashboard_insight_generator.dart';

class DashboardBuilder {
  const DashboardBuilder();

  DashboardViewModel build({
    required String userName,
    required CalendarViewModel calendar,
    required List<Habit> habits,
  }) {
    //--------------------------------------------------
    // Hero Statistics
    //--------------------------------------------------

    final totalXP = habits.fold<int>(
      0,
      (sum, habit) => sum + habit.xp,
    );

    final currentStreak = habits.fold<int>(
      0,
      (sum, habit) => sum + habit.currentStreak,
    );

    final bestStreak = habits.fold<int>(
      0,
      (sum, habit) => sum + habit.bestStreak,
    );

    final completedToday = habits.where((habit) => habit.completedToday).length;

    final totalToday = habits.length;

    //--------------------------------------------------
    // Level Calculation
    //--------------------------------------------------

    const xpPerLevel = 100;

    final level = (totalXP ~/ xpPerLevel) + 1;

    final nextLevelXP = level * xpPerLevel;

    final previousLevelXP = (level - 1) * xpPerLevel;

    final xpProgress = totalXP <= 0
        ? 0.0
        : ((totalXP - previousLevelXP) / (nextLevelXP - previousLevelXP))
            .clamp(0.0, 1.0);

    //--------------------------------------------------
    // Hero ViewModel
    //--------------------------------------------------

    final hero = HeroViewModel(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      totalXP: totalXP,
      level: level,
      completedToday: completedToday,
      totalToday: totalToday,
      nextLevelXP: nextLevelXP,
      xpProgress: xpProgress,
    );

    //--------------------------------------------------
    // Insights
    //--------------------------------------------------

    const generator = DashboardInsightGenerator();

    final insights = generator.generate(hero);

    //--------------------------------------------------
    // Analytics
    //--------------------------------------------------

    final analytics = [
      AnalyticsCardModel(
        type: DashboardMetricType.streak,
        title: 'Current Streak',
        value: '$currentStreak',
        trend: '+2 this week',
      ),
      AnalyticsCardModel(
        type: DashboardMetricType.habits,
        title: 'Total Habits',
        value: '${habits.length}',
        trend: 'Active',
      ),
      AnalyticsCardModel(
        type: DashboardMetricType.completion,
        title: 'Completion',
        value: '${hero.progressPercentage}%',
        trend: 'Today',
      ),
    ];

    //--------------------------------------------------
    // Today's Habits
    //--------------------------------------------------

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

        // TODO: Replace after Difficulty is added to Habit model.
        difficulty: "Medium",
      );
    }).toList();

    //--------------------------------------------------
    // Recent Activity
    //--------------------------------------------------

    final activities = [
      ActivityItem(
        id: "1",
        title: "Study completed",
        description: "Completed today's study session",
        icon: Icons.menu_book,
        color: const Color(0xFF4CAF50),
        status: ActivityStatus.completed,
        date: DateTime.now().subtract(
          const Duration(minutes: 15),
        ),
        xp: 10,
      ),
      ActivityItem(
        id: "2",
        title: "Exercise completed",
        description: "Morning workout finished",
        icon: Icons.fitness_center,
        color: const Color(0xFF2196F3),
        status: ActivityStatus.completed,
        date: DateTime.now().subtract(
          const Duration(hours: 2),
        ),
        xp: 20,
      ),
    ];

    //--------------------------------------------------
    // Dashboard ViewModel
    //--------------------------------------------------

    return DashboardViewModel(
      greeting: _greeting(),
      userName: userName,
      hero: hero,
      analytics: analytics,
      todayHabits: todayHabits,
      calendar: calendar,
      weekly: const <DailyStatistics>[],
      activities: activities,
      actions: _defaultActions(),
      insights: insights,
      hasHabits: todayHabits.isNotEmpty,
      hasActivities: activities.isNotEmpty,
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
      return "Good Morning";
    }

    if (hour < 17) {
      return "Good Afternoon";
    }

    return "Good Evening";
  }
}
