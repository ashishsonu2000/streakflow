import 'package:flutter/material.dart';

import '../models/hero_view_model.dart';
import '../models/insight_item.dart';

class DashboardInsightGenerator {
  const DashboardInsightGenerator();

  List<InsightItem> generate(
    HeroViewModel hero,
  ) {
    final insights = <InsightItem>[];

    //----------------------------------------
    // Streak
    //----------------------------------------

    if (hero.currentStreak >= 7) {
      insights.add(
        const InsightItem(
          title: "Amazing!",
          message: "You're maintaining a great streak.",
          icon: Icons.local_fire_department,
          color: Colors.orange,
        ),
      );
    }

    //----------------------------------------
    // XP
    //----------------------------------------

    if (hero.totalXP < 100) {
      insights.add(
        const InsightItem(
          title: "Keep Going",
          message: "Complete one more habit to earn more XP.",
          icon: Icons.stars,
          color: Colors.amber,
        ),
      );
    }

    //----------------------------------------
    // Completion
    //----------------------------------------

    if (hero.completedToday == 0) {
      insights.add(
        const InsightItem(
          title: "Start Today",
          message: "Complete your first habit today.",
          icon: Icons.check_circle,
          color: Colors.green,
        ),
      );
    }

    return insights;
  }
}
