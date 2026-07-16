import 'package:flutter/material.dart';

class CalendarWeekdays extends StatelessWidget {
  const CalendarWeekdays({super.key});

  static const days = [
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
  ];

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;

    return Row(
      children: days
          .map(
            (day) => Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    day,
                    style: style,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
