import '../../data/entities/habit_frequency.dart';
import 'habit.dart';
import 'habit_category.dart';

class HabitFormState {
  const HabitFormState({
    this.originalHabit,
    this.title = '',
    this.description = '',
    this.category = HabitCategory.health,
    this.frequency = HabitFrequency.daily,
    this.iconCodePoint = 0xe318, // Icons.check_circle.codePoint
    this.colorValue = 0xFF4CAF50, // Green
    this.targetPerDay = 1,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,
    this.isEditing = false,
    this.isSaving = false,
    this.error,
  });

  /// Existing habit when editing.
  final Habit? originalHabit;

  /// Form fields
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

  /// UI State
  final bool isEditing;
  final bool isSaving;

  final String? error;

  bool get isCreateMode => !isEditing;

  bool get isEditMode => isEditing;

  bool get hasReminder =>
      reminderEnabled && reminderHour != null && reminderMinute != null;

  bool get isValid => title.trim().isNotEmpty;

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
    bool? isEditing,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return HabitFormState(
      originalHabit:
          clearOriginalHabit ? null : originalHabit ?? this.originalHabit,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      targetPerDay: targetPerDay ?? this.targetPerDay,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour:
          clearReminderHour ? null : reminderHour ?? this.reminderHour,
      reminderMinute:
          clearReminderMinute ? null : reminderMinute ?? this.reminderMinute,
      isEditing: isEditing ?? this.isEditing,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : error ?? this.error,
    );
  }

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
  isEditing: $isEditing,
  isSaving: $isSaving,
  error: $error,
)
''';
  }

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
        isEditing,
        isSaving,
        error,
      );
}
