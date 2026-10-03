import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.colors = _defaultColors,
    this.circleSize = 44,
    this.spacing = AppSpacing.md,
  });

  final int selectedColor;

  final ValueChanged<int> onColorSelected;

  final List<Color> colors;

  final double circleSize;

  final double spacing;

  static const List<Color> _defaultColors = [
    Color(0xFF4CAF50), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFF9C27B0), // Purple
    Color(0xFFE91E63), // Pink
    Color(0xFFFF9800), // Orange
    Color(0xFFF44336), // Red
    Color(0xFF009688), // Teal
    Color(0xFF3F51B5), // Indigo
    Color(0xFF00BCD4), // Cyan
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
    Color(0xFF8BC34A), // Light Green
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: colors.map((color) {
        final selected = color.toARGB32() == selectedColor;

        return InkWell(
          borderRadius: BorderRadius.circular(circleSize),
          onTap: () => onColorSelected(color.toARGB32()),
          child: AnimatedContainer(
            duration: AppDuration.fast,
            curve: Curves.easeInOut,
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.45),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: AnimatedOpacity(
              duration: AppDuration.fast,
              opacity: selected ? 1 : 0,
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
