import 'package:flutter/material.dart';

class CalendarLegend extends StatelessWidget {
  const CalendarLegend({
    super.key,
  });

  Widget _item(
      BuildContext context,
      Color color,
      String text,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      mainAxisSize:
      MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
            BorderRadius.circular(3),
          ),
        ),

        const SizedBox(
          width: 6,
        ),

        Text(
          text,
          style:
          theme.textTheme.bodySmall?.copyWith(
            color:
            colors.onSurfaceVariant,
            fontSize: 11,
            fontWeight:
            FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final scheme =
        theme.colorScheme;

    final base =
        scheme.primary;

    final isDark =
        theme.brightness ==
            Brightness.dark;

    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      child: Wrap(
        spacing: 16,
        runSpacing: 8,

        children: [
          _item(
            context,
            isDark
                ? scheme.surfaceContainerHighest
                : scheme.surfaceContainerHighest,
            'None',
          ),

          _item(
            context,
            base.withValues(
              alpha:
              isDark ? 0.24 : 0.20,
            ),
            'Low',
          ),

          _item(
            context,
            base.withValues(
              alpha:
              isDark ? 0.44 : 0.40,
            ),
            'Medium',
          ),

          _item(
            context,
            base.withValues(
              alpha:
              isDark ? 0.68 : 0.65,
            ),
            'High',
          ),

          _item(
            context,
            base,
            'Perfect',
          ),
        ],
      ),
    );
  }
}