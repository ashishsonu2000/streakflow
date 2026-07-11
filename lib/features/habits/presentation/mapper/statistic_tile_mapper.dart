import 'package:flutter/material.dart';

import '../../domain/models/habit_statistics.dart';
import '../../domain/models/statistic_tile.dart';

class StatisticTileMapper {
  const StatisticTileMapper();

  List<StatisticTileModel> map(
    HabitStatistics statistics,
  ) {
    return [
      StatisticTileModel(
        title: "Current Streak",
        value: statistics.currentStreak.toString(),
        icon: Icons.local_fire_department,
        color: Colors.orange,
      ),
      StatisticTileModel(
        title: "Best Streak",
        value: statistics.bestStreak.toString(),
        icon: Icons.emoji_events,
        color: Colors.amber,
      ),
      StatisticTileModel(
        title: "Completed",
        value: statistics.totalCompleted.toString(),
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      StatisticTileModel(
        title: "XP Earned",
        value: statistics.totalXP.toString(),
        icon: Icons.stars,
        color: Colors.blue,
      ),
    ];
  }
}
