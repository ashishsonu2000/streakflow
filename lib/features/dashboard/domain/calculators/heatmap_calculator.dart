import '../../../habits/data/entities/habit_log_entity.dart';

class HeatmapCalculator {
  const HeatmapCalculator._();

  static Map<DateTime, int> calculate(
    List<HabitLogEntity> logs,
  ) {
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

    return map;
  }
}
