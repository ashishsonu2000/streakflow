import '../../data/entities/habit_log_entity.dart';
import '../../../dashboard/domain/models/heatmap_day.dart';

class HeatmapCalculator {
  const HeatmapCalculator._();

  static List<HeatmapDay> calculate(
    List<HabitLogEntity> logs,
  ) {
    final counts = <DateTime, int>{};

    for (final log in logs) {
      final day = DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      );

      counts.update(
        day,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    final result = counts.entries
        .map(
          (entry) => HeatmapDay(
            date: entry.key,
            count: entry.value,
            completed: entry.value > 0,
          ),
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return result;
  }
}
