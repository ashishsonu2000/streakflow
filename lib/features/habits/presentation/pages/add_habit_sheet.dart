import 'package:flutter/material.dart';

import '../widgets/habit_form.dart';

class AddHabitSheet extends StatelessWidget {
  const AddHabitSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const AddHabitSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: 24,
      ),
      child: HabitForm(),
    );
  }
}
