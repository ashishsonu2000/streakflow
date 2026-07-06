import 'package:isar_community/isar.dart';

import '../../domain/models/habit_category.dart';

import 'habit_frequency.dart';
import 'habit_log_entity.dart';
import 'sync_status.dart';
part 'habit_entity.g.dart';

@collection
class HabitEntity {
  HabitEntity();

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index(caseSensitive: false)
  late String title;

  String description = "";

  @Enumerated(EnumType.name)
  HabitCategory category = HabitCategory.personal;

  @Enumerated(EnumType.name)
  HabitFrequency frequency = HabitFrequency.daily;

  int iconCodePoint = 0;

  int colorValue = 0;

  int targetPerDay = 1;

  int currentStreak = 0;

  int bestStreak = 0;

  int totalCompleted = 0;

  int xp = 0;

  bool reminderEnabled = false;

  int? reminderHour;

  int? reminderMinute;

  bool archived = false;

  bool deleted = false;

  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();

  DateTime? lastCompletedDate;

  bool completedToday = false;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  int version = 1;

  final logs = IsarLinks<HabitLogEntity>();
}
