import 'package:flutter/material.dart';

import '../../../../core/ui/insights/insight_item.dart';
import '../models/hero_view_model.dart';

class DashboardInsightGenerator {
  const DashboardInsightGenerator();

  List<InsightItem> generate(HeroViewModel hero) {
    final insights = <InsightItem>[];

    //------------------------------------------
    // Today's Completion
    //------------------------------------------

    if (hero.totalToday > 0) {
      if (hero.completedToday == hero.totalToday) {
        insights.add(
          const InsightItem(
            title: 'Perfect Day',
            message: 'Amazing! You completed all of your habits today.',
            icon: Icons.emoji_events_rounded,
            color: Colors.green,
          ),
        );
      } else if (hero.completedToday == 0) {
        insights.add(
          const InsightItem(
            title: 'Get Started',
            message: 'Complete your first habit today to begin your streak.',
            icon: Icons.play_circle_outline_rounded,
            color: Colors.blue,
          ),
        );
      } else {
        insights.add(
          InsightItem(
            title: 'Daily Progress',
            message:
                'You have completed ${hero.completedToday} of ${hero.totalToday} habits today.',
            icon: Icons.check_circle_outline_rounded,
            color: Colors.teal,
          ),
        );
      }
    }

    //------------------------------------------
    // Current Streak
    //------------------------------------------

    if (hero.currentStreak >= 100) {
      insights.add(
        InsightItem(
          title: 'Legendary Streak',
          message:
              'Outstanding! You have maintained a ${hero.currentStreak}-day streak.',
          icon: Icons.local_fire_department_rounded,
          color: Colors.deepOrange,
        ),
      );
    } else if (hero.currentStreak >= 30) {
      insights.add(
        InsightItem(
          title: 'Fantastic Consistency',
          message: 'Your ${hero.currentStreak}-day streak is truly impressive.',
          icon: Icons.local_fire_department_rounded,
          color: Colors.orange,
        ),
      );
    } else if (hero.currentStreak >= 7) {
      insights.add(
        InsightItem(
          title: 'Great Momentum',
          message: 'You have stayed consistent for ${hero.currentStreak} days.',
          icon: Icons.trending_up_rounded,
          color: Colors.amber,
        ),
      );
    } else if (hero.currentStreak > 0) {
      insights.add(
        const InsightItem(
          title: 'Keep Going',
          message: 'Every completed habit strengthens your routine.',
          icon: Icons.favorite_rounded,
          color: Colors.pink,
        ),
      );
    }

    //------------------------------------------
    // XP Progress
    //------------------------------------------

    if (hero.xpProgress >= 0.90) {
      insights.add(
        InsightItem(
          title: 'Almost There',
          message: 'You are very close to reaching Level ${hero.level + 1}.',
          icon: Icons.stars_rounded,
          color: Colors.deepPurple,
        ),
      );
    } else if (hero.xpProgress >= 0.50) {
      insights.add(
        const InsightItem(
          title: 'Level Progress',
          message: 'You are making solid progress towards your next level.',
          icon: Icons.workspace_premium_rounded,
          color: Colors.indigo,
        ),
      );
    }

    //------------------------------------------
    // Personal Best
    //------------------------------------------

    if (hero.bestStreak > hero.currentStreak && hero.currentStreak > 0) {
      insights.add(
        InsightItem(
          title: 'Personal Best',
          message:
              'Only ${hero.bestStreak - hero.currentStreak} more days to match your best streak.',
          icon: Icons.flag_rounded,
          color: Colors.redAccent,
        ),
      );
    }

    //------------------------------------------
    // Default Motivation
    //------------------------------------------

    if (insights.isEmpty) {
      insights.add(
        const InsightItem(
          title: 'Daily Motivation',
          message:
              'Small daily actions create extraordinary long-term results.',
          icon: Icons.eco_rounded,
          color: Colors.green,
        ),
      );
    }

    return insights;
  }
}
