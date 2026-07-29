import 'level_summary.dart';
import 'xp_summary.dart';

class ProgressionSummary {
  const ProgressionSummary({
    required this.level,
    required this.xp,
  });

  final LevelSummary level;

  final XpSummary xp;
}
