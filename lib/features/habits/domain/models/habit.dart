import '../enums/habit_frequency.dart';
import 'difficulty.dart';
import 'habit_category.dart';

class Habit {
  final String id;

  final String title;

  final String description;

  final HabitCategory category;

  final HabitFrequency frequency;

  final int iconCodePoint;

  final int colorValue;

  final int targetPerDay;

  final int currentStreak;

  final int bestStreak;

  final int totalCompleted;

  final int xp;

  final bool reminderEnabled;

  final int? reminderHour;

  final int? reminderMinute;

  final bool archived;

  final DateTime createdAt;

  final DateTime updatedAt;

  final DateTime? lastCompletedDate;

  final bool completedToday;

  // =========================================================
  // Habit Schedule
  // =========================================================

  /// Date from which this habit becomes active.
  final DateTime startDate;

  /// Optional date on which this habit ends.
  ///
  /// null = ongoing habit.
  final DateTime? endDate;

  // =========================================================
  // Weekly Schedule
  // =========================================================

  /// Weekdays on which a weekly habit should occur.
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
  /// means Monday, Wednesday and Friday.
  final List<int> weeklyDays;

  // =========================================================
  // Monthly Schedule
  // =========================================================

  /// Day of the month on which a monthly habit should occur.
  ///
  /// Valid values:
  ///
  /// 1 - 31
  ///
  /// Example:
  ///
  /// 15 = 15th day of every month.
  ///
  /// If a month does not contain the selected day
  /// (for example February 30), the schedule logic should
  /// decide how to handle that occurrence.
  final int monthlyDay;

  // =========================================================
  // Habit Metadata
  // =========================================================

  final int estimatedDurationMinutes;

  final Difficulty difficulty;

  final int xpReward;

  const Habit({
    required this.id,
    required this.title,
    this.description = '',
    this.category = HabitCategory.personal,
    this.frequency = HabitFrequency.daily,
    this.iconCodePoint = 0,
    this.colorValue = 0,
    this.targetPerDay = 1,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalCompleted = 0,
    this.xp = 0,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,
    this.archived = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastCompletedDate,
    this.completedToday = false,

    // =======================================================
    // Schedule
    // =======================================================

    required this.startDate,
    this.endDate,

    // Weekly schedule
    this.weeklyDays = const <int>[],

    // Monthly schedule
    this.monthlyDay = 1,

    // =======================================================
    // Metadata
    // =======================================================

    this.estimatedDurationMinutes = 15,
    this.difficulty = Difficulty.easy,
    this.xpReward = 5,
  });

  // =========================================================
  // Convenience Getters
  // =========================================================

  bool get isDaily =>
      frequency == HabitFrequency.daily;

  bool get isWeekly =>
      frequency == HabitFrequency.weekly;

  bool get isMonthly =>
      frequency == HabitFrequency.monthly;

  bool get isCustom =>
      frequency == HabitFrequency.custom;

  bool get hasWeeklySchedule =>
      weeklyDays.isNotEmpty;

  bool get hasMonthlySchedule =>
      monthlyDay >= 1 &&
          monthlyDay <= 31;

  // =========================================================
  // Copy With
  // =========================================================

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    HabitCategory? category,
    HabitFrequency? frequency,
    int? iconCodePoint,
    int? colorValue,
    int? targetPerDay,
    int? currentStreak,
    int? bestStreak,
    int? totalCompleted,
    int? xp,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastCompletedDate,
    bool? completedToday,

    // Schedule
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,

    // Weekly schedule
    List<int>? weeklyDays,

    // Monthly schedule
    int? monthlyDay,

    // Metadata
    int? estimatedDurationMinutes,
    Difficulty? difficulty,
    int? xpReward,
  }) {
    return Habit(
      id:
      id ?? this.id,

      title:
      title ?? this.title,

      description:
      description ?? this.description,

      category:
      category ?? this.category,

      frequency:
      frequency ?? this.frequency,

      iconCodePoint:
      iconCodePoint ?? this.iconCodePoint,

      colorValue:
      colorValue ?? this.colorValue,

      targetPerDay:
      targetPerDay ?? this.targetPerDay,

      currentStreak:
      currentStreak ?? this.currentStreak,

      bestStreak:
      bestStreak ?? this.bestStreak,

      totalCompleted:
      totalCompleted ?? this.totalCompleted,

      xp:
      xp ?? this.xp,

      reminderEnabled:
      reminderEnabled ?? this.reminderEnabled,

      reminderHour:
      reminderHour ?? this.reminderHour,

      reminderMinute:
      reminderMinute ?? this.reminderMinute,

      archived:
      archived ?? this.archived,

      createdAt:
      createdAt ?? this.createdAt,

      updatedAt:
      updatedAt ?? this.updatedAt,

      lastCompletedDate:
      lastCompletedDate ??
          this.lastCompletedDate,

      completedToday:
      completedToday ??
          this.completedToday,

      // =====================================================
      // Schedule
      // =====================================================

      startDate:
      startDate ?? this.startDate,

      endDate:
      clearEndDate
          ? null
          : endDate ?? this.endDate,

      // =====================================================
      // Weekly schedule
      // =====================================================

      weeklyDays:
      weeklyDays ?? this.weeklyDays,

      // =====================================================
      // Monthly schedule
      // =====================================================

      monthlyDay:
      monthlyDay ?? this.monthlyDay,

      // =====================================================
      // Metadata
      // =====================================================

      estimatedDurationMinutes:
      estimatedDurationMinutes ??
          this.estimatedDurationMinutes,

      difficulty:
      difficulty ?? this.difficulty,

      xpReward:
      xpReward ?? this.xpReward,
    );
  }

  // =========================================================
  // Debug
  // =========================================================

  @override
  String toString() {
    return '''
Habit(
  id: $id,
  title: $title,
  description: $description,
  category: $category,
  frequency: $frequency,
  weeklyDays: $weeklyDays,
  monthlyDay: $monthlyDay,
  iconCodePoint: $iconCodePoint,
  colorValue: $colorValue,
  targetPerDay: $targetPerDay,
  currentStreak: $currentStreak,
  bestStreak: $bestStreak,
  totalCompleted: $totalCompleted,
  xp: $xp,
  reminderEnabled: $reminderEnabled,
  reminderHour: $reminderHour,
  reminderMinute: $reminderMinute,
  archived: $archived,
  createdAt: $createdAt,
  updatedAt: $updatedAt,
  lastCompletedDate: $lastCompletedDate,
  completedToday: $completedToday,
  startDate: $startDate,
  endDate: $endDate,
  estimatedDurationMinutes: $estimatedDurationMinutes,
  difficulty: $difficulty,
  xpReward: $xpReward,
)
''';
  }
}