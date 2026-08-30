import 'package:isar_community/isar.dart';

import '../../domain/enums/habit_frequency.dart';
import '../../domain/models/habit_category.dart';

import 'habit_log_entity.dart';
import 'sync_status.dart';

part 'habit_entity.g.dart';

@collection
class HabitEntity {
  HabitEntity();

  // =========================================================
  // Primary Key
  // =========================================================

  Id id = Isar.autoIncrement;

  // =========================================================
  // Identity
  // =========================================================

  @Index(unique: true)
  late String uuid;

  @Index(caseSensitive: false)
  late String title;

  String description = "";

  // =========================================================
  // Habit Configuration
  // =========================================================

  @Enumerated(EnumType.name)
  HabitCategory category = HabitCategory.personal;

  @Enumerated(EnumType.name)
  HabitFrequency frequency = HabitFrequency.daily;

  int iconCodePoint = 0;

  int colorValue = 0;

  int targetPerDay = 1;

  // =========================================================
  // Progress
  // =========================================================

  int currentStreak = 0;

  int bestStreak = 0;

  int totalCompleted = 0;

  int xp = 0;

  // =========================================================
  // Reminder
  // =========================================================

  bool reminderEnabled = false;

  int? reminderHour;

  int? reminderMinute;

  // =========================================================
  // Status
  // =========================================================

  bool archived = false;

  bool deleted = false;

  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();

  DateTime? lastCompletedDate;

  bool completedToday = false;

  // =========================================================
  // Habit Schedule
  // =========================================================

  /// First date on which the habit is active.
  ///
  /// Nullable for backward compatibility
  /// with existing records.
  DateTime? startDate;

  /// Last date on which the habit is active.
  ///
  /// null = ongoing.
  DateTime? endDate;

  // =========================================================
  // Weekly Recurrence
  // =========================================================

  /// Weekdays on which a weekly habit occurs.
  ///
  /// DateTime weekday values:
  ///
  /// 1 = Monday
  /// 2 = Tuesday
  /// 3 = Wednesday
  /// 4 = Thursday
  /// 5 = Friday
  /// 6 = Saturday
  /// 7 = Sunday
  ///
  /// Example:
  ///
  /// [1, 3, 5]
  ///
  /// = Monday, Wednesday, Friday.
  ///
  /// Empty for non-weekly habits.
  List<int> weeklyDays = [];

  // =========================================================
  // Monthly Recurrence
  // =========================================================

  /// Day of the month on which a monthly habit occurs.
  ///
  /// Valid values: 1-31.
  ///
  /// Example:
  ///
  /// 15 = 15th day of every month.
  ///
  /// Defaults to 1 for backward compatibility.
  int monthlyDay = 1;

  // =========================================================
  // Synchronization
  // =========================================================

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.pending;

  int version = 1;

  // =========================================================
  // Habit Logs
  // =========================================================

  final logs = IsarLinks<HabitLogEntity>();
}