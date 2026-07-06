import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import 'color_picker_sheet.dart';

class ColorPickerTile extends StatelessWidget {
  const ColorPickerTile({
    super.key,
    required this.selectedColor,
    required this.onChanged,
  });

  final int selectedColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
      ),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      leading: CircleAvatar(
        backgroundColor: Color(selectedColor),
      ),
      title: const Text('Color'),
      subtitle: const Text('Tap to change'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final color = await showModalBottomSheet<int>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (_) => ColorPickerSheet(
            selectedColor: selectedColor,
          ),
        );

        if (color != null) {
          onChanged(color);
        }
      },
    );
  }
}
