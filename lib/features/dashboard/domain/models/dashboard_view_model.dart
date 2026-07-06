import 'package:flutter/material.dart';

import 'activity_item.dart';
import 'habit_summary.dart';
import 'quick_action.dart';
import 'streak_summary.dart';
import 'weekly_progress.dart';

class DashboardViewModel {
  final String greeting;
  final String userName;

  final StreakSummary streak;

  final List<HabitSummary> habits;

  final List<QuickAction> actions;

  final List<WeeklyProgress> weekly;

  final List<ActivityItem> recentActivity;

  const DashboardViewModel({
    required this.greeting,
    required this.userName,
    required this.streak,
    required this.habits,
    required this.actions,
    required this.weekly,
    required this.recentActivity,
  });
}
