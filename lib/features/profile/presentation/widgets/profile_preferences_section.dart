import 'package:flutter/material.dart';

class ProfilePreferencesSection
    extends StatelessWidget {
  const ProfilePreferencesSection({
    super.key,
    required this.notificationsEnabled,
  });

  final bool notificationsEnabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.notifications,
            ),
            title: const Text(
              'Notifications',
            ),
            subtitle: Text(
              notificationsEnabled
                  ? 'Enabled'
                  : 'Disabled',
            ),
          ),
        ],
      ),
    );
  }
}