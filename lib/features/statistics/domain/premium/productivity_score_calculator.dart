import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../models/statistics_summary.dart';

/// StreakFlow Premium productivity score (0–100) for the selected week.
///
///   completion   50 pts  weekly completion rate (completed / scheduled)
///   consistency  30 pts  scheduled days so far with ≥1 completion
///   streak       20 pts  current streak, full marks at 14 days
///
/// Derived only from the existing StatisticsEngine output; it never
/// changes any statistic.
@immutable
class ProductivityScore {
  const ProductivityScore({
    required this.score,
    required this.completionPoints,
    required this.consistencyPoints,
    required this.streakPoints,
  });

  static const maxCompletion = 50;
  static const maxConsistency = 30;
  static const maxStreak = 20;
  static const streakForFullMarks = 14;

  final int score;
  final int completionPoints;
  final int consistencyPoints;
  final int streakPoints;

  String get label => switch (score) {
        >= 80 => 'Excellent',
        >= 60 => 'Strong',
        >= 40 => 'Building momentum',
        _ => 'Getting started',
      };
}

abstract final class ProductivityScoreCalculator {
  static ProductivityScore calculate(
    StatisticsSummary summary, {
    DateTime? today,
  }) {
    final now = today ?? DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final completionRate = summary.weekly.completionRate.clamp(0.0, 1.0);

    // Only days that have happened and had something scheduled count,
    // so the score isn't penalized early in the week.
    final scheduledDays = summary.weekly.days
        .where((d) => d.targetHabits > 0 && !d.date.isAfter(endOfToday))
        .toList();
    final activeDays =
        scheduledDays.where((d) => d.completedHabits > 0).length;
    final consistency =
        scheduledDays.isEmpty ? 0.0 : activeDays / scheduledDays.length;

    final streak = math.min(
          summary.overview.currentStreak,
          ProductivityScore.streakForFullMarks,
        ) /
        ProductivityScore.streakForFullMarks;

    final completionPoints =
        (completionRate * ProductivityScore.maxCompletion).round();
    final consistencyPoints =
        (consistency * ProductivityScore.maxConsistency).round();
    final streakPoints = (streak * ProductivityScore.maxStreak).round();

    return ProductivityScore(
      score: (completionPoints + consistencyPoints + streakPoints)
          .clamp(0, 100),
      completionPoints: completionPoints,
      consistencyPoints: consistencyPoints,
      streakPoints: streakPoints,
    );
  }
}
