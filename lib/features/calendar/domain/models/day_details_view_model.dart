import '../../presentation/widgets/day_details/day_timeline.dart';

class DayDetailsViewModel {
  const DayDetailsViewModel({
    required this.date,
    required this.completedHabits,
    required this.totalHabits,
    required this.totalXP,
    required this.totalDuration,
    required this.timeline,
  });

  final DateTime date;

  final int completedHabits;

  final int totalHabits;

  final int totalXP;

  final int totalDuration;

  final List<DayTimelineItem> timeline;

  double get completionRate =>
      totalHabits == 0 ? 0 : completedHabits / totalHabits;
}
