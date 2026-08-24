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

    this.isEditing = false,
    this.isSaving = false,
    this.error,
  }) : startDate = startDate ?? _today();

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

  bool get isValid =>
      title.trim().isNotEmpty &&
          !isEndDateBeforeStart;

  bool get isEndDateBeforeStart {
    if (endDate == null) {
      return false;
    }

    return _dateOnly(endDate!)
        .isBefore(
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

    bool? isEditing,
    bool? isSaving,

    String? error,
    bool clearError = false,
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

      reminderHour:
      clearReminderHour
          ? null
          : reminderHour ?? this.reminderHour,

      reminderMinute:
      clearReminderMinute
          ? null
          : reminderMinute ?? this.reminderMinute,

      // Schedule
      startDate:
      startDate ?? this.startDate,

      endDate:
      clearEndDate
          ? null
          : endDate ?? this.endDate,

      isEditing:
      isEditing ?? this.isEditing,

      isSaving:
      isSaving ?? this.isSaving,

      error:
      clearError
          ? null
          : error ?? this.error,
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
            iconCodePoint == other.iconCodePoint &&
            colorValue == other.colorValue &&
            targetPerDay == other.targetPerDay &&
            reminderEnabled == other.reminderEnabled &&
            reminderHour == other.reminderHour &&
            reminderMinute == other.reminderMinute &&
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
}