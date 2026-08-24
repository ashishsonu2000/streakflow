import 'package:flutter/material.dart';

import '../../domain/models/notification_request.dart';
import '../../domain/services/notification_service.dart';

class NotificationTestPage
    extends StatelessWidget {
  const NotificationTestPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Test',
        ),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () async {
            final now =
            DateTime.now();

            await NotificationService()
                .showNow();

            if (!context.mounted) {
              return;
            }

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              const SnackBar(
                content: Text(
                  'Notification sent.',
                ),
              ),
            );
          },
          child: const Text(
            'Schedule Reminder',
          ),
        ),
      ),
    );
  }
}