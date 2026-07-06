import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../models/dashboard_analytics.dart';
import '../models/dashboard_view_model.dart';
import '../models/habit_summary.dart';
import '../models/quick_action.dart';
import '../models/quick_action_type.dart';
import '../models/streak_summary.dart';
import '../models/weekly_progress.dart';

class DashboardViewModelMapper {
  const DashboardViewModelMapper();

  DashboardViewModel map(
    DashboardAnalytics analytics,
    List<HabitSummary> habits,
    List<QuickAction> actions,
    String userName,
  ) {
    return DashboardViewModel(
      greeting: DateFormatter.greeting(),
      userName: userName,
      streak: StreakSummary(
        currentStreak: analytics.currentStreak,
        longestStreak: analytics.longestStreak,
        completedDays: analytics.completedDays,
        targetDays: analytics.targetDays,
        completion: analytics.progress,
        level: analytics.level,
        xp: analytics.totalXp,
        xpTarget: analytics.xpTarget,
        achievement: analytics.achievement,
      ),
      habits: habits,
      actions: actions,
      weekly: analytics.weeklyProgress
          .map(
            (e) => WeeklyProgress(
              day: _day(e.date.weekday),
              completed: e.completed,
            ),
          )
          .toList(),
      recentActivity: analytics.recentActivity,
    );
  }

  String _day(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "M";
      case DateTime.tuesday:
        return "T";
      case DateTime.wednesday:
        return "W";
      case DateTime.thursday:
        return "T";
      case DateTime.friday:
        return "F";
      case DateTime.saturday:
        return "S";
      case DateTime.sunday:
        return "S";
      default:
        return "";
    }
  }
}
