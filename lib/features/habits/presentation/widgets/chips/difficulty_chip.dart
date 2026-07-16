import 'package:flutter/material.dart';

import '../../../../../core/ui/chips/app_chip.dart';
import '../../../domain/extensions/difficulty_extension.dart';
import '../../../domain/models/difficulty.dart';

class DifficultyChip extends StatelessWidget {
  const DifficultyChip({
    super.key,
    required this.difficulty,
  });

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: difficulty.label,
      color: difficulty.color,
      icon: difficulty.icon,
    );
  }
}
