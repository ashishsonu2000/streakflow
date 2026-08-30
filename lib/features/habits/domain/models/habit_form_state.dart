import '../enums/habit_frequency.dart';
import 'habit.dart';
import 'habit_category.dart';

DateTime _today() {
  final now = DateTime.now();

  return DateTime(
    now.year,
    now.month,
    now.day,
  );
}

class HabitFormState {
  HabitFormState({
    this.originalHabit,
    this.title = '',
    this.description = '',
    this.category = HabitCategory.health,
    this.frequency = HabitFrequency.daily,
    this.iconCodePoint = 0xe318,
    this.colorValue = 0xFF4CAF50,
    this.targetPerDay = 1,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,

    // Schedule
    DateTime? startDate,
    this.endDate,

    // Weekly schedule
    List<int>? weeklyDays,

    this.isEditing = false,
    this.isSaving = false,
    this.error,
    this.monthlyDay = 1,
  })  : startDate = startDate ?? _today(),
        weeklyDays = _normalizeWeeklyDays(
          weeklyDays ??
              [
                (startDate ?? _today()).weekday,
              ],
        );

  final Habit? originalHabit;

  final String title;
  final String description;

  final HabitCategory category;
  final HabitFrequency frequency;

  final int iconCodePoint;
  final int colorValue;

  final int targetPerDay;

  final bool reminderEnabled;
  final int? reminderHour;
  final int? reminderMinute;

  // =========================================================
  // Schedule
  // =========================================================

  /// First day on which the habit is active.
  final DateTime startDate;

  /// Last day on which the habit is active.
  ///
  /// null = ongoing habit.
  final DateTime? endDate;

  // =========================================================
  // Weekly Schedule
  // =========================================================

  /// Selected weekdays for a weekly habit.
  ///
  /// Dart DateTime weekday values:
  ///
  /// 1 = Monday
  /// 2 = Tuesday
  /// 3 = Wednesday
  /// 4 = Thursday
  /// 5 = Friday
  /// 6 = Saturday
  /// 7 = Sunday
  final List<int> weeklyDays;

  final int monthlyDay;

  // =========================================================
  // Form state
  // =========================================================

  final bool isEditing;
  final bool isSaving;

  final String? error;

  // =========================================================
  // Getters
  // =========================================================

  bool get isCreateMode => !isEditing;

  bool get isEditMode => isEditing;

  bool get hasReminder =>
      reminderEnabled &&
          reminderHour != null &&
          reminderMinute != null;

  bool get hasEndDate => endDate != null;

  bool get isWeekly =>
      frequency == HabitFrequency.weekly;

  bool get isValid =>
      title.trim().isNotEmpty &&
          !isEndDateBeforeStart &&
          (!isWeekly || weeklyDays.isNotEmpty);

  bool get isEndDateBeforeStart {
    if (endDate == null) {
      return false;
    }

    return _dateOnly(endDate!).isBefore(
      _dateOnly(startDate),
    );
  }

  // =========================================================
  // Helpers
  // =========================================================

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // =========================================================
  // Copy With
  // =========================================================

  HabitFormState copyWith({
    Habit? originalHabit,
    bool clearOriginalHabit = false,

    String? title,
    String? description,

    HabitCategory? category,
    HabitFrequency? frequency,

    int? iconCodePoint,
    int? colorValue,
    int? targetPerDay,

    bool? reminderEnabled,
    int? reminderHour,
    bool clearReminderHour = false,
    int? reminderMinute,
    bool clearReminderMinute = false,

    // Schedule
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,

    // Weekly schedule
    List<int>? weeklyDays,

    bool? isEditing,
    bool? isSaving,

    String? error,
    bool clearError = false,
    int? monthlyDay,
  }) {
    return HabitFormState(
      originalHabit: clearOriginalHabit
          ? null
          : originalHabit ?? this.originalHabit,

      title: title ?? this.title,
      description: description ?? this.description,

      category: category ?? this.category,
      frequency: frequency ?? this.frequency,

      iconCodePoint:
      iconCodePoint ?? this.iconCodePoint,

      colorValue:
      colorValue ?? this.colorValue,

      targetPerDay:
      targetPerDay ?? this.targetPerDay,

      reminderEnabled:
      reminderEnabled ?? this.reminderEnabled,

      reminderHour: clearReminderHour
          ? null
          : reminderHour ?? this.reminderHour,

      reminderMinute: clearReminderMinute
          ? null
          : reminderMinute ?? this.reminderMinute,

      // Schedule
      startDate:
      startDate ?? this.startDate,

      endDate: clearEndDate
          ? null
          : endDate ?? this.endDate,

      // Weekly schedule
      weeklyDays:
      weeklyDays ?? this.weeklyDays,

      isEditing:
      isEditing ?? this.isEditing,

      isSaving:
      isSaving ?? this.isSaving,

      error: clearError
          ? null
          : error ?? this.error,
      monthlyDay:
      monthlyDay ??
          (startDate ?? _today()).day,
    );
  }

  // =========================================================
  // Debug
  // =========================================================

  @override
  String toString() {
    return '''
HabitFormState(
  title: $title,
  description: $description,
  category: $category,
  frequency: $frequency,
  weeklyDays: $weeklyDays,
  targetPerDay: $targetPerDay,
  reminderEnabled: $reminderEnabled,
  reminderHour: $reminderHour,
  reminderMinute: $reminderMinute,
  startDate: $startDate,
  endDate: $endDate,
  isEditing: $isEditing,
  isSaving: $isSaving,
  error: $error,
)
''';
  }

  // =========================================================
  // Equality
  // =========================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HabitFormState &&
            runtimeType == other.runtimeType &&
            originalHabit == other.originalHabit &&
            title == other.title &&
            description == other.description &&
            category == other.category &&
            frequency == other.frequency &&
            _listEquals(
              weeklyDays,
              other.weeklyDays,
            ) &&
            iconCodePoint == other.iconCodePoint &&
            colorValue == other.colorValue &&
            targetPerDay == other.targetPerDay &&
            reminderEnabled ==
                other.reminderEnabled &&
            reminderHour ==
                other.reminderHour &&
            reminderMinute ==
                other.reminderMinute &&
            startDate == other.startDate &&
            endDate == other.endDate &&
            isEditing == other.isEditing &&
            isSaving == other.isSaving &&
            error == other.error;
  }

  @override
  int get hashCode => Object.hash(
    originalHabit,
    title,
    description,
    category,
    frequency,
    Object.hashAll(weeklyDays),
    iconCodePoint,
    colorValue,
    targetPerDay,
    reminderEnabled,
    reminderHour,
    reminderMinute,
    startDate,
    endDate,
    isEditing,
    isSaving,
    error,
  );

  // =========================================================
  // Static Helpers
  // =========================================================

  static List<int> _normalizeWeeklyDays(
      List<int> days,
      ) {
    return days
        .where(
          (day) => day >= 1 && day <= 7,
    )
        .toSet()
        .toList()
      ..sort();
  }

  static bool _listEquals(
      List<int> a,
      List<int> b,
      ) {
    if (a.length != b.length) {
      return false;
    }

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }
}