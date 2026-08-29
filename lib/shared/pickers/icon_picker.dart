import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';
import '../../core/ui/icons/habit_icon_resolver.dart';

class IconPicker extends StatelessWidget {
  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    this.icons = habitPickerIcons,
    this.iconSize = 22,
    this.itemSize = 52,
  });

  /// Selected icon codePoint.
  final int selectedIcon;

  /// Callback when icon changes.
  final ValueChanged<int> onIconSelected;

  /// Icons to display.
  final List<IconData> icons;

  /// Icon size.
  final double iconSize;

  /// Size of each tile.
  final double itemSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: icons.map((icon) {
        final selected =
            icon.codePoint == selectedIcon;

        return InkWell(
          borderRadius:
          BorderRadius.circular(12),
          onTap: () =>
              onIconSelected(icon.codePoint),
          child: AnimatedContainer(
            duration: AppDuration.fast,
            curve: Curves.easeInOut,
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              color: selected
                  ? colorScheme.primaryContainer
                  : colorScheme
                  .surfaceContainerHighest,
              borderRadius:
              BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: AnimatedScale(
              duration: AppDuration.fast,
              scale: selected ? 1.1 : 1,
              child: Icon(
                icon,
                size: iconSize,
                color: selected
                    ? colorScheme.primary
                    : colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}