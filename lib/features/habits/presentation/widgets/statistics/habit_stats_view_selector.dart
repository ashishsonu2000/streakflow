import 'package:flutter/material.dart';

// =====================================================================
// VIEW SELECTOR
// =====================================================================

class HabitStatsViewSelector extends StatelessWidget {
  const HabitStatsViewSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: colors.outlineVariant
              .withValues(alpha: 0.65),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          _ViewButton(
            label: 'Overview',
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _ViewButton(
            label: 'Week',
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
          _ViewButton(
            label: 'Month',
            selected: selectedIndex == 2,
            onTap: () => onChanged(2),
          ),
          _ViewButton(
            label: 'Year',
            selected: selectedIndex == 3,
            onTap: () => onChanged(3),
          ),
        ],
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? colors.primary
                : Colors.transparent,
            borderRadius:
            BorderRadius.circular(11),
          ),
          child: Text(
            label,
            style: theme
                .textTheme
                .labelMedium
                ?.copyWith(
              color: selected
                  ? colors.onPrimary
                  : colors.onSurfaceVariant,
              fontWeight: selected
                  ? FontWeight.w700
                  : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
