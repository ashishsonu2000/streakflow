import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_form_provider.dart';
import 'habit_icons.dart';

class HabitIconPickerSheet extends ConsumerWidget {
  const HabitIconPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).value!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: HabitIcons.icons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (_, index) {
            final icon = HabitIcons.icons[index];

            final selected = state.iconCodePoint == icon.codePoint;

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                ref.read(habitFormProvider.notifier).setIcon(icon.codePoint);

                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon),
              ),
            );
          },
        ),
      ),
    );
  }
}
