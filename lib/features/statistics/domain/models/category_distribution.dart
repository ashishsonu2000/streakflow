import '../../../habits/domain/models/habit_category.dart';

class CategoryDistribution {
  const CategoryDistribution({
    required this.category,
    required this.count,
    required this.percentage,
  });

  final HabitCategory category;

  final int count;

  final double percentage;
}