import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/ui/icons/habit_icon_resolver.dart';
import 'icon_picker_sheet.dart';

class IconPickerTile extends StatelessWidget {
  const IconPickerTile({
    super.key,
    required this.selectedIcon,
    required this.onChanged,
  });

  final int selectedIcon;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
      ),
      tileColor: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context)
            .colorScheme
            .primaryContainer,
        child: Icon(
          habitIconFromCodePoint(
            selectedIcon,
          ),
        ),
      ),
      title: const Text('Icon'),
      subtitle: const Text('Tap to change'),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      onTap: () async {
        final icon =
        await showModalBottomSheet<int>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => IconPickerSheet(
            selectedIcon: selectedIcon,
          ),
        );

        if (icon != null) {
          onChanged(icon);
        }
      },
    );
  }
}