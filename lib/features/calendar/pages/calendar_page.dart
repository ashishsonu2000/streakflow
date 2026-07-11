import 'package:flutter/material.dart';

import '../widgets/calendar_grid.dart';
import '../widgets/calendar_header.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CalendarHeader(),
            Expanded(
              child: CalendarMonthGrid(),
            ),
          ],
        ),
      ),
    );
  }
}
