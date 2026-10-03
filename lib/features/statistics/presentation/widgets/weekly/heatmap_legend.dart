import 'package:flutter/material.dart';

class HeatmapLegend extends StatelessWidget {
  const HeatmapLegend({
    super.key,
  });

  Widget _item(
      BuildContext context,
      String label,
      Color color,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
            BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: [
        _item(
          context,
          '0',
          theme.colorScheme
              .surfaceContainerHighest,
        ),
        _item(
          context,
          '1',
          theme.colorScheme.primary
              .withValues(alpha: 0.4),
        ),
        _item(
          context,
          '2+',
          theme.colorScheme.primary,
        ),
      ],
    );
  }
}