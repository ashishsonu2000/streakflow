import '../../../habits/domain/models/habit_log.dart';

import '../models/heatmap_day.dart';

class HeatmapBuilder {
  const HeatmapBuilder();

  List<HeatmapDay> build(
      List<HabitLog> logs,
      ) {
    final today = DateTime.now();

    final map = <DateTime, int>{};

    for (final log in logs) {
      final day = DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      );

      map.update(
        day,
            (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    final result = <HeatmapDay>[];

    for (var i = 41; i >= 0; i--) {
      final day = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(
        Duration(days: i),
      );

      result.add(
        HeatmapDay(
          date: day,
          completions: map[day] ?? 0,
        ),
      );
    }

    return result;
  }
}