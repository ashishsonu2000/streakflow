import '../../../../habits/data/entities/mood_type.dart';

class DayTimelineItem {
  const DayTimelineItem({
    required this.title,
    required this.completedAt,
    required this.durationMinutes,
    required this.xpEarned,
    required this.notes,
    required this.mood,
  });

  final String title;

  final DateTime? completedAt;

  final int durationMinutes;

  final int xpEarned;

  final String notes;

  final MoodType? mood;
}
