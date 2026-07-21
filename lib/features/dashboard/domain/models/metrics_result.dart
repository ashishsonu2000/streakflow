import 'package:flutter/foundation.dart';

@immutable
class MetricsResult {
  const MetricsResult({
    required this.totalHabits,
    required this.activeHabits,
    required this.archivedHabits,
    required this.completedToday,
    required this.pendingToday,
    required this.totalCompletions,
  });

  final int totalHabits;
  final int activeHabits;
  final int archivedHabits;
  final int completedToday;
  final int pendingToday;
  final int totalCompletions;
}
