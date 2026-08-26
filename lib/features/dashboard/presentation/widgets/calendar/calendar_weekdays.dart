import 'package:flutter/material.dart';

class CalendarWeekdays extends StatelessWidget {
  const CalendarWeekdays({
    super.key,
  });

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
    return Row(
      children: days.map(
            (day) {
          return Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: Text(
                  day,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: const Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}