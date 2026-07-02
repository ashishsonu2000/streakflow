import 'package:isar_community/isar.dart';

import 'completion_status.dart';
import 'habit_entity.dart';
import 'mood_type.dart';

part 'habit_log_entity.g.dart';

@collection
class HabitLogEntity {
  HabitLogEntity();

  Id id = Isar.autoIncrement;

  /// Link to Habit
  final habit = IsarLink<HabitEntity>();

  @Index()
  late DateTime date;

  @Enumerated(EnumType.name)
  CompletionStatus status = CompletionStatus.completed;

  DateTime? completedAt;

  int durationMinutes = 0;

  int xpEarned = 0;

  @Enumerated(EnumType.name)
  MoodType? mood;

  String notes = "";

  DateTime createdAt = DateTime.now();
}
