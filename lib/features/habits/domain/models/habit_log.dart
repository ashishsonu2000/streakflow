import '../enums/completion_status.dart';
import '../enums/mood_type.dart';

class HabitLog {
  const HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
    required this.status,
    required this.completedAt,
    required this.durationMinutes,
    required this.notes,
    required this.xpEarned,
    this.mood,
  });

  final String id;

  final String habitId;

  final DateTime date;

  final CompletionStatus status;

  final DateTime? completedAt;

  final int durationMinutes;

  final String notes;

  final int xpEarned;

  final MoodType? mood;

  HabitLog copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    CompletionStatus? status,
    DateTime? completedAt,
    int? durationMinutes,
    String? notes,
    int? xpEarned,
    MoodType? mood,
  }) {
    return HabitLog(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      xpEarned: xpEarned ?? this.xpEarned,
      mood: mood ?? this.mood,
    );
  }
}
