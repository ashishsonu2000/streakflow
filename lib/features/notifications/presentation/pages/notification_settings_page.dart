import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../providers/notification_service_provider.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final notificationState =
    ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(
            context,
            'Notification Settings',
          ),

          const SizedBox(height: 8),

          Card(
            child: SwitchListTile.adaptive(
              secondary: Icon(
                notificationState.enabled
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_outlined,
              ),
              title: const Text(
                'Habit Reminders',
              ),
              subtitle: Text(
                notificationState.enabled
                    ? 'Get reminded about your habits'
                    : 'Notifications are currently disabled',
              ),
              value: notificationState.enabled,
              onChanged: notificationState.isLoading
                  ? null
                  : (enabled) async {
                final success =
                await ref
                    .read(
                  notificationProvider
                      .notifier,
                )
                    .setEnabled(enabled);

                if (!context.mounted) {
                  return;
                }

                if (enabled && !success) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Notification permission was not granted.',
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle(
            context,
            'Test Notification',
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              enabled: notificationState.enabled &&
                  !notificationState.isLoading,
              leading: const Icon(
                Icons.notifications_active_outlined,
              ),
              title: const Text(
                'Send Test Notification',
              ),
              subtitle: Text(
                notificationState.enabled
                    ? 'Verify that notifications are working'
                    : 'Enable notifications first',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: notificationState.enabled
                  ? () async {
                final success =
                await ref
                    .read(
                  notificationProvider
                      .notifier,
                )
                    .sendTestNotification();

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Test notification sent.'
                          : 'Unable to send test notification.',
                    ),
                  ),
                );
              }
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle(
            context,
            'About Notifications',
          ),

          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Notifications are used to remind '
                          'you about habits that have reminders '
                          'enabled.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
      BuildContext context,
      String title,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 4,
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}