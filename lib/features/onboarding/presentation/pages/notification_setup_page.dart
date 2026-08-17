import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/onboarding_provider.dart';

class NotificationSetupPage extends ConsumerWidget {
  const NotificationSetupPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final enabled =
        ref.watch(
          onboardingProvider,
        ).notificationsEnabled;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            size: 96,
          ),
          const SizedBox(height: 24),
          const Text(
            'Daily reminders',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Enable notifications',
            ),
            value: enabled,
            onChanged: (value) {
              ref
                  .read(
                onboardingProvider.notifier,
              )
                  .setNotifications(value);
            },
          ),
        ],
      ),
    );
  }
}