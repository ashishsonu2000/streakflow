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

    // Weekly
    List<int>? weeklyDays,

    // Monthly
    int? monthlyDay,

    this.isEditing = false,
    this.isSaving = false,
    this.error,
  })  : startDate = startDate ?? _today(),
        weeklyDays = _normalizeWeeklyDays(
          weeklyDays ?? const <int>[],
        ),
        monthlyDay = _normalizeMonthlyDay(
          monthlyDay ?? (startDate ?? _today()).day,
        );

  // =========================================================
  // ORIGINAL HABIT
  // =========================================================

  final Habit? originalHabit;

  // =========================================================
  // BASIC
  // =========================================================

  final String title;

  final String description;

  final HabitCategory category;

  final HabitFrequency frequency;

  final int iconCodePoint;

  final int colorValue;

  final int targetPerDay;

  // =========================================================
  // REMINDER
  // =========================================================

  final bool reminderEnabled;

  final int? reminderHour;

  final int? reminderMinute;

  // =========================================================
  // SCHEDULE
  // =========================================================

  /// First day on which the habit is active.
  final DateTime startDate;

  /// Last day on which the habit is active.
  ///
  /// null = ongoing.
  final DateTime? endDate;

  // =========================================================
  // WEEKLY SCHEDULE
  // =========================================================

  /// Selected weekdays.
  ///
  /// 1 = Monday
  /// 2 = Tuesday
  /// 3 = Wednesday
  /// 4 = Thursday
  /// 5 = Friday
  /// 6 = Saturday
  /// 7 = Sunday
  final List<int> weeklyDays;

  // =========================================================
  // MONTHLY SCHEDULE
  // =========================================================

  /// Selected day of the month.
  ///
  /// Valid values: 1-31.
  final int monthlyDay;

  // =========================================================
  // FORM STATE
  // =========================================================

  final bool isEditing;

  final bool isSaving;

  final String? error;

  // =========================================================
  // GETTERS
  // =========================================================

  bool get isCreateMode =>
      !isEditing;

  bool get isEditMode =>
      isEditing;

  bool get hasReminder =>
      reminderEnabled &&
          reminderHour != null &&
          reminderMinute != null;

  bool get hasEndDate =>
      endDate != null;

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

  bool get isValid =>
      title.trim().isNotEmpty &&
          !isEndDateBeforeStart &&
          _isFrequencyConfigurationValid;

  bool get _isFrequencyConfigurationValid {
    if (frequency == HabitFrequency.weekly) {
      return weeklyDays.isNotEmpty;
    }

    if (frequency == HabitFrequency.monthly) {
      return monthlyDay >= 1 &&
          monthlyDay <= 31;
    }

    if (frequency == HabitFrequency.custom) {
      return weeklyDays.isNotEmpty;
    }

    return true;
  }

  bool get isEndDateBeforeStart {
    if (endDate == null) {
      return false;
    }

    return _dateOnly(endDate!).isBefore(
      _dateOnly(startDate),
    );
  }

  // =========================================================
  // HELPERS
  // =========================================================

  DateTime _dateOnly(
      DateTime date,
      ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // =========================================================
  // COPY WITH
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

    // Weekly
    List<int>? weeklyDays,

    // Monthly
    int? monthlyDay,

    bool? isEditing,
    bool? isSaving,

    String? error,
    bool clearError = false,
  }) {
    return HabitFormState(
      originalHabit: clearOriginalHabit
          ? null
          : originalHabit ??
          this.originalHabit,

      title:
      title ?? this.title,

      description:
      description ?? this.description,

      category:
      category ?? this.category,

      frequency:
      frequency ?? this.frequency,

      iconCodePoint:
      iconCodePoint ??
          this.iconCodePoint,

      colorValue:
      colorValue ??
          this.colorValue,

      targetPerDay:
      targetPerDay ??
          this.targetPerDay,

      // Reminder
      reminderEnabled:
      reminderEnabled ??
          this.reminderEnabled,

      reminderHour:
      clearReminderHour
          ? null
          : reminderHour ??
          this.reminderHour,

      reminderMinute:
      clearReminderMinute
          ? null
          : reminderMinute ??
          this.reminderMinute,

      // Schedule
      startDate:
      startDate ?? this.startDate,

      endDate:
      clearEndDate
          ? null
          : endDate ?? this.endDate,

      // Weekly
      weeklyDays:
      weeklyDays ??
          this.weeklyDays,

      // Monthly
      monthlyDay:
      monthlyDay ??
          this.monthlyDay,

      // Form
      isEditing:
      isEditing ??
          this.isEditing,

      isSaving:
      isSaving ??
          this.isSaving,

      error:
      clearError
          ? null
          : error ?? this.error,
    );
  }

  // =========================================================
  // DEBUG
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
  monthlyDay: $monthlyDay,
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
  // EQUALITY
  // =========================================================

  @override
  bool operator ==(
      Object other,
      ) {
    return identical(
      this,
      other,
    ) ||
        other is HabitFormState &&
            runtimeType ==
                other.runtimeType &&
            originalHabit ==
                other.originalHabit &&
            title ==
                other.title &&
            description ==
                other.description &&
            category ==
                other.category &&
            frequency ==
                other.frequency &&
            _listEquals(
              weeklyDays,
              other.weeklyDays,
            ) &&
            monthlyDay ==
                other.monthlyDay &&
            iconCodePoint ==
                other.iconCodePoint &&
            colorValue ==
                other.colorValue &&
            targetPerDay ==
                other.targetPerDay &&
            reminderEnabled ==
                other.reminderEnabled &&
            reminderHour ==
                other.reminderHour &&
            reminderMinute ==
                other.reminderMinute &&
            startDate ==
                other.startDate &&
            endDate ==
                other.endDate &&
            isEditing ==
                other.isEditing &&
            isSaving ==
                other.isSaving &&
            error ==
                other.error;
  }

  @override
  int get hashCode =>
      Object.hash(
        originalHabit,
        title,
        description,
        category,
        frequency,
        Object.hashAll(
          weeklyDays,
        ),
        monthlyDay,
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
  // STATIC HELPERS
  // =========================================================

  static List<int> _normalizeWeeklyDays(
      List<int> days,
      ) {
    return days
        .where(
          (day) =>
      day >= 1 &&
          day <= 7,
    )
        .toSet()
        .toList()
      ..sort();
  }

  static int _normalizeMonthlyDay(
      int day,
      ) {
    if (day < 1) {
      return 1;
    }

    if (day > 31) {
      return 31;
    }

    return day;
  }

  static bool _listEquals(
      List<int> a,
      List<int> b,
      ) {
    if (a.length != b.length) {
      return false;
    }

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }
}