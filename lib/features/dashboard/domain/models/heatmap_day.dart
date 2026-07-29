class HeatmapDay {
  const HeatmapDay({
    required this.date,
    required this.count,
    required this.completed,
  });

  /// Calendar day.
  final DateTime date;

  /// Number of completions on this day.
  final int count;

  /// Whether the day reached the completion target.
  final bool completed;

  bool get hasActivity => count > 0;

  HeatmapDay copyWith({
    DateTime? date,
    int? count,
    bool? completed,
  }) {
    return HeatmapDay(
      date: date ?? this.date,
      count: count ?? this.count,
      completed: completed ?? this.completed,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HeatmapDay &&
            date == other.date &&
            count == other.count &&
            completed == other.completed;
  }

  @override
  int get hashCode => Object.hash(
        date,
        count,
        completed,
      );
}
