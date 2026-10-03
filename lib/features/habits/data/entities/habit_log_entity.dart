import 'package:isar_community/isar.dart';

import '../../domain/enums/completion_status.dart';
import '../../domain/enums/mood_type.dart';
import 'habit_entity.dart';

part 'habit_log_entity.g.dart';

@collection
class HabitLogEntity {
  HabitLogEntity();

  Id id = Isar.autoIncrement;

  /// Habit reference
  final habit = IsarLink<HabitEntity>();

  @Index()
  late DateTime date;

  @Enumerated(EnumType.name)
  CompletionStatus status = CompletionStatus.completed;

  /// Time when the habit was completed
  DateTime? completedAt;

  /// Actual duration spent
  int durationMinutes = 0;

  /// XP earned for this completion
  int xpEarned = 0;

  @Enumerated(EnumType.name)
  MoodType? mood;

  /// Optional user notes
  String notes = "";

  /// Prevent multiple completions for the same habit on the same day
  @Index()
  late String habitId;

  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();
}
