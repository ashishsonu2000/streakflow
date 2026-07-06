import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_form_provider.dart';
import 'habit_colors.dart';
import 'habit_icon_picker_sheet.dart';

class HabitAppearanceCard extends ConsumerWidget {
  const HabitAppearanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).value!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Color(state.colorValue),
                child: Icon(
                  IconData(
                    state.iconCodePoint,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: Colors.white,
                ),
              ),
              title: const Text("Appearance"),
              subtitle: const Text("Choose icon and color"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const HabitIconPickerSheet(),
                );
              },
            ),
            const Divider(),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: HabitColors.colors.map((color) {
                return InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    ref
                        .read(habitFormProvider.notifier)
                        .setColor(color.toARGB32());
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: color,
                    child: state.colorValue == color.toARGB32()
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          )
                        : null,
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
