import 'package:flutter/material.dart';

import '../domain/models/activity_item.dart';
import '../domain/models/activity_status.dart';
import '../domain/models/dashboard_metrics.dart';
import '../domain/models/dashboard_summary.dart';
import '../domain/models/habit_summary.dart';
import '../domain/models/quick_action.dart';
import '../domain/models/streak_summary.dart';
import '../domain/models/weekly_progress.dart';

class DashboardRepository {
  DashboardSummary loadDashboard() {
    return DashboardSummary(
      greeting: "Good Morning",
      userName: "Ashish",
      streak: const StreakSummary(
        currentStreak: 18,
        longestStreak: 36,
        completedDays: 18,
        targetDays: 25,
        completion: 0.72,
        level: 7,
        xp: 1240,
        xpTarget: 1500,
        achievement: "Consistency Champion",
      ),
      habits: const [
        HabitSummary(
          id: "1",
          title: "Workout",
          subtitle: "Morning Routine",
          icon: Icons.directions_run,
          color: Colors.orange,
          completed: true,
          points: 5,
          streak: 18,
        ),
        HabitSummary(
          id: "2",
          title: "Reading",
          subtitle: "Read 30 Minutes",
          icon: Icons.menu_book,
          color: Colors.blue,
          completed: true,
          points: 3,
          streak: 14,
        ),
        HabitSummary(
          id: "3",
          title: "Meditation",
          subtitle: "10 Minute Session",
          icon: Icons.self_improvement,
          color: Colors.purple,
          completed: false,
          points: 2,
          streak: 7,
        ),
        HabitSummary(
          id: "4",
          title: "Drink Water",
          subtitle: "8 Glasses Today",
          icon: Icons.water_drop,
          color: Colors.lightBlue,
          completed: true,
          points: 1,
          streak: 25,
        ),
      ],
      actions: const [
        QuickAction(
          title: "Add Habit",
          icon: Icons.add_circle_outline,
        ),
        QuickAction(
          title: "Calendar",
          icon: Icons.calendar_month,
        ),
        QuickAction(
          title: "Statistics",
          icon: Icons.bar_chart,
        ),
        QuickAction(
          title: "Settings",
          icon: Icons.settings,
        ),
      ],
      weekly: const [
        WeeklyProgress(day: "M", completed: true),
        WeeklyProgress(day: "T", completed: true),
        WeeklyProgress(day: "W", completed: true),
        WeeklyProgress(day: "T", completed: false),
        WeeklyProgress(day: "F", completed: true),
        WeeklyProgress(day: "S", completed: true),
        WeeklyProgress(day: "S", completed: true),
      ],
      metrics: const DashboardMetrics(
        totalHabits: 4,
        completedToday: 3,
        pendingToday: 1,
        weeklyCompletion: 82,
      ),
      recentActivity: const [
        ActivityItem(
          id: "1",
          title: "Workout",
          description: "Morning Routine",
          icon: Icons.directions_run,
          color: Colors.orange,
          time: "2 min ago",
          status: ActivityStatus.completed,
        ),
        ActivityItem(
          id: "2",
          title: "Reading",
          description: "30 Minutes",
          icon: Icons.menu_book,
          color: Colors.blue,
          time: "Today • 08:30 AM",
          status: ActivityStatus.completed,
        ),
        ActivityItem(
          id: "3",
          title: "Meditation",
          description: "10 Minutes",
          icon: Icons.self_improvement,
          color: Colors.purple,
          time: "Yesterday",
          status: ActivityStatus.skipped,
        ),
        ActivityItem(
          id: "4",
          title: "Drink Water",
          description: "8 Glasses",
          icon: Icons.water_drop,
          color: Colors.cyan,
          time: "Yesterday • 07:15 PM",
          status: ActivityStatus.completed,
        ),
      ],
    );
  }
}
