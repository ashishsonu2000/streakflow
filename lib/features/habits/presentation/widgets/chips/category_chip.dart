import 'package:flutter/material.dart';

import '../../../../../core/ui/chips/app_chip.dart';
import '../../../domain/extensions/habit_category_extension.dart';
import '../../../domain/models/habit_category.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
  });

  final HabitCategory category;

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: category.label,
      color: category.color,
      icon: category.icon,
    );
  }
}
