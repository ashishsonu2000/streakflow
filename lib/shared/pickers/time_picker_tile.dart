import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class TimePickerTile extends StatelessWidget {
  const TimePickerTile({
    super.key,
    required this.title,
    required this.time,
    required this.onChanged,
    this.subtitle,
    this.leading,
    this.enabled = true,
  });

  final String title;
  final TimeOfDay? time;
  final String? subtitle;
  final IconData? leading;
  final bool enabled;

  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    final display = time == null
        ? 'Not set'
        : MaterialLocalizations.of(context).formatTimeOfDay(time!);

    return Card(
      elevation: 0,
      child: ListTile(
        enabled: enabled,
        leading: Icon(
          leading ?? AppIcons.reminder,
        ),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              display,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: enabled
            ? () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: time ?? TimeOfDay.now(),
                );

                if (picked != null) {
                  onChanged(picked);
                }
              }
            : null,
      ),
    );
  }
}
