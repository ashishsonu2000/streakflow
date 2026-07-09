import 'package:flutter/material.dart';

import 'habit_filter_bar.dart';
import 'habit_search_bar.dart';
import 'habit_sort_button.dart';

class HabitProductivityHeader extends StatelessWidget {
  const HabitProductivityHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HabitSearchBar(),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: HabitFilterBar(),
            ),
            const SizedBox(width: 12),
            const HabitSortButton(),
          ],
        ),
      ],
    );
  }
}
