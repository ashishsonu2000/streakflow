import 'package:flutter/material.dart';

import '../../../../../core/ui/metadata/app_metadata_row.dart';
import '../../../domain/models/habit.dart';

class HabitCardMetadata extends StatelessWidget {
  const HabitCardMetadata({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return AppMetadataRow(
      items: [
        MetadataItem(
          icon: Icons.category_outlined,
          label: _capitalize(habit.category.name),
        ),

        MetadataItem(
          icon: Icons.repeat_rounded,
          label: _capitalize(habit.frequency.name),
        ),

        MetadataItem(
          icon: Icons.flag_outlined,
          label: '${habit.targetPerDay}/day',
        ),
      ],
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}