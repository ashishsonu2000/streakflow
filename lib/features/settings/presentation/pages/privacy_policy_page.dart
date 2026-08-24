import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Privacy Policy',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Last updated: August 20, 2026',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),

          const SizedBox(height: 24),

          _PolicySection(
            title: '1. Overview',
            text:
            'Streak Calculator is a habit tracking application designed to help you build and maintain positive habits through streaks, statistics, achievements, reminders, and progress tracking.',
          ),

          _PolicySection(
            title: '2. Data Storage',
            text:
            'Your habit data, activity history, profile information, statistics, and application preferences are primarily stored locally on your device.',
          ),

          _PolicySection(
            title: '3. Personal Information',
            text:
            'Streak Calculator does not require you to create an online account. The application does not intentionally collect personal information from you for advertising or profiling purposes.',
          ),

          _PolicySection(
            title: '4. Notifications',
            text:
            'If you enable reminders, Streak Calculator may schedule notifications on your device to remind you about your habits. Notifications can be disabled through the application settings or your device settings.',
          ),

          _PolicySection(
            title: '5. Backup and Restore',
            text:
            'When you use Backup & Restore, the application creates a backup file containing the data necessary to restore your application information. The backup is shared or stored only when you explicitly initiate the export or import process.',
          ),

          _PolicySection(
            title: '6. Third-Party Services',
            text:
            'The application may use platform services and Flutter libraries to provide functionality such as notifications, file sharing, and application review. These services may process information according to their own privacy policies.',
          ),

          _PolicySection(
            title: '7. Data Security',
            text:
            'Because application data is primarily stored locally, you are responsible for protecting access to your device and any exported backup files.',
          ),

          _PolicySection(
            title: '8. Changes to This Policy',
            text:
            'This Privacy Policy may be updated from time to time. Any updated version will be made available within the application.',
          ),

          _PolicySection(
            title: '9. Contact',
            text:
            'If you have questions, suggestions, or concerns regarding this Privacy Policy, please contact the Streak Calculator support team.',
          ),

          const SizedBox(height: 24),

          Text(
            'Streak Calculator',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}