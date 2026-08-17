class HeatmapDay {
  const HeatmapDay({
    required this.date,
    required this.count,
    required this.isCompleted,
  });

  /// Calendar day.
  final DateTime date;

  /// Number of completions on this day.
  final int count;

  /// Whether the day reached the completion target.
  final bool isCompleted;

  bool get hasActivity => count > 0;

  HeatmapDay copyWith({
    DateTime? date,
    int? count,
    bool? completed,
  }) {
    return HeatmapDay(
      date: date ?? this.date,
      count: count ?? this.count,
      isCompleted: completed ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HeatmapDay &&
            date == other.date &&
            count == other.count &&
            isCompleted == other.isCompleted;
  }

  @override
  int get hashCode => Object.hash(
        date,
        count,
        isCompleted,
      );
}
