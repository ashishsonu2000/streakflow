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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          text,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final base = scheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _item(
            context,
            scheme.surfaceContainerHighest,
            'None',
          ),

          _item(
            context,
            base.withValues(alpha: 0.20),
            'Low',
          ),

          _item(
            context,
            base.withValues(alpha: 0.40),
            'Medium',
          ),

          _item(
            context,
            base.withValues(alpha: 0.65),
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