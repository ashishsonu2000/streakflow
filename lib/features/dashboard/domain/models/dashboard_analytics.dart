import 'package:equatable/equatable.dart';

import '../../../../core/progression/models/level_summary.dart';
import '../../../calendar/domain/models/calendar_view_model.dart';
import '../../../statistics/domain/models/daily_statistics.dart';

import 'activity_item.dart';
import 'analytics_card_model.dart';
import 'heatmap_day.dart';

class DashboardAnalytics extends Equatable {
  const DashboardAnalytics({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalHabits,
    required this.completedToday,
    required this.pendingToday,
    required this.weeklyCompletion,
    required this.monthlyCompletion,
    required this.completionRate,
    required this.progress,
    required this.perfectDays,
    required this.completedDays,
    required this.targetDays,
    required this.cards,
    required this.calendar,
    required this.weekly,
    required this.recentActivity,
    required this.heatmap,
    required this.levelSummary,
  });

  //------------------------------------------
  // Streak
  //------------------------------------------

  final int currentStreak;
  final int longestStreak;

  //------------------------------------------
  // Habit Metrics
  //------------------------------------------

  final int totalHabits;
  final int completedToday;
  final int pendingToday;

  final double weeklyCompletion;
  final double monthlyCompletion;
  final double completionRate;
  final double progress;

  //------------------------------------------
  // Calendar Metrics
  //------------------------------------------

  final int perfectDays;
  final int completedDays;
  final int targetDays;

  //------------------------------------------
  // Dashboard UI
  //------------------------------------------

  final List<AnalyticsCardModel> cards;
  final CalendarViewModel calendar;
  final List<DailyStatistics> weekly;
  final List<ActivityItem> recentActivity;
  final List<HeatmapDay> heatmap;

  //------------------------------------------
  // Progression
  //------------------------------------------

  final LevelSummary levelSummary;

  DashboardAnalytics copyWith({
    int? currentStreak,
    int? longestStreak,
    int? totalHabits,
    int? completedToday,
    int? pendingToday,
    double? weeklyCompletion,
    double? monthlyCompletion,
    double? completionRate,
    double? progress,
    int? perfectDays,
    int? completedDays,
    int? targetDays,
    List<AnalyticsCardModel>? cards,
    CalendarViewModel? calendar,
    List<DailyStatistics>? weekly,
    List<ActivityItem>? recentActivity,
    List<HeatmapDay>? heatmap,
    LevelSummary? levelSummary,
  }) {
    return DashboardAnalytics(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalHabits: totalHabits ?? this.totalHabits,
      completedToday: completedToday ?? this.completedToday,
      pendingToday: pendingToday ?? this.pendingToday,
      weeklyCompletion: weeklyCompletion ?? this.weeklyCompletion,
      monthlyCompletion: monthlyCompletion ?? this.monthlyCompletion,
      completionRate: completionRate ?? this.completionRate,
      progress: progress ?? this.progress,
      perfectDays: perfectDays ?? this.perfectDays,
      completedDays: completedDays ?? this.completedDays,
      targetDays: targetDays ?? this.targetDays,
      cards: cards ?? this.cards,
      calendar: calendar ?? this.calendar,
      weekly: weekly ?? this.weekly,
      recentActivity: recentActivity ?? this.recentActivity,
      heatmap: heatmap ?? this.heatmap,
      levelSummary: levelSummary ?? this.levelSummary,
    );
  }

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        totalHabits,
        completedToday,
        pendingToday,
        weeklyCompletion,
        monthlyCompletion,
        completionRate,
        progress,
        perfectDays,
        completedDays,
        targetDays,
        cards,
        calendar,
        weekly,
        recentActivity,
        heatmap,
        levelSummary,
      ];

  factory DashboardAnalytics.empty({
    required CalendarViewModel calendar,
  }) {
    return DashboardAnalytics(
      currentStreak: 0,
      longestStreak: 0,
      totalHabits: 0,
      completedToday: 0,
      pendingToday: 0,
      weeklyCompletion: 0,
      monthlyCompletion: 0,
      completionRate: 0,
      progress: 0,
      perfectDays: 0,
      completedDays: 0,
      targetDays: 0,
      cards: const [],
      calendar: calendar,
      weekly: const [],
      recentActivity: const [],
      heatmap: const [],
      levelSummary: const LevelSummary(
        level: 1,
        totalXp: 0,
        previousLevelXp: 0,
        currentLevelXp: 0,
        nextLevelXp: 100,
        remainingXp: 100,
        progress: 0,
      ),
    );
  }
}
