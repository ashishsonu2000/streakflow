import 'package:flutter/material.dart';

import '../../../../shared/ui/layouts/layouts.dart';
import '../widgets/habit_preview_card.dart';

class HabitPreviewSection extends StatelessWidget {
  const HabitPreviewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AppSection(
      title: 'Preview',
      subtitle: 'See how your habit will appear.',
      child: HabitPreviewCard(),
    );
  }
}
