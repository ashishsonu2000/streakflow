import 'package:flutter/material.dart';

class ActivityTimelineIndicator extends StatelessWidget {
  const ActivityTimelineIndicator({
    super.key,
    required this.completed,
  });

  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      alignment: Alignment.topCenter,
      child: CircleAvatar(
        radius: 16,
        backgroundColor:
        completed
            ? Colors.green
            : Colors.red,
        child: Icon(
          completed
              ? Icons.check
              : Icons.close,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}