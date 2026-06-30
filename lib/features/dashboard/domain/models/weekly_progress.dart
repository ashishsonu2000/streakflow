import 'package:equatable/equatable.dart';

class WeeklyProgress extends Equatable {
  final String day;
  final bool completed;

  const WeeklyProgress({
    required this.day,
    required this.completed,
  });

  @override
  List<Object?> get props => [
        day,
        completed,
      ];
}
