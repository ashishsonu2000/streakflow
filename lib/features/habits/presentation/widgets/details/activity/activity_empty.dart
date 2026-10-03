import 'package:flutter/material.dart';

class ActivityEmpty extends StatelessWidget {
  const ActivityEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 32,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 48,
            ),
            SizedBox(height: 12),
            Text(
              'No activity yet',
            ),
          ],
        ),
      ),
    );
  }
}