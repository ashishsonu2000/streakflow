import 'package:flutter/material.dart';

class RecentActivityEmpty extends StatelessWidget {
  const RecentActivityEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 32,
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 56,
          ),
          SizedBox(height: 16),
          Text(
            'No activity yet',
          ),
        ],
      ),
    );
  }
}