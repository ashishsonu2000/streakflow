import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';

class IconPicker extends StatelessWidget {
  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    this.icons = _defaultIcons,
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

  static const List<IconData> _defaultIcons = [
    Icons.favorite,
    Icons.favorite_border,
    Icons.fitness_center,
    Icons.directions_run,
    Icons.self_improvement,
    Icons.sports_gymnastics,
    Icons.water_drop,
    Icons.local_fire_department,
    Icons.restaurant,
    Icons.fastfood,
    Icons.local_cafe,
    Icons.bedtime,
    Icons.nightlight_round,
    Icons.menu_book,
    Icons.school,
    Icons.work_outline,
    Icons.code,
    Icons.laptop_mac,
    Icons.phone_android,
    Icons.computer,
    Icons.brush,
    Icons.music_note,
    Icons.headphones,
    Icons.camera_alt,
    Icons.photo,
    Icons.travel_explore,
    Icons.flight_takeoff,
    Icons.hiking,
    Icons.directions_bike,
    Icons.pets,
    Icons.spa,
    Icons.eco,
    Icons.yard,
    Icons.park,
    Icons.celebration,
    Icons.star,
    Icons.lightbulb_outline,
    Icons.psychology,
    Icons.auto_awesome,
    Icons.task_alt,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: icons.map((icon) {
        final selected = icon.codePoint == selectedIcon;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onIconSelected(icon.codePoint),
          child: AnimatedContainer(
            duration: AppDuration.fast,
            curve: Curves.easeInOut,
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              color: selected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? colorScheme.primary : Colors.transparent,
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
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
