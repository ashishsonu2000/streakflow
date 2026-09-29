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
            'Last updated: September 29, 2026',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),

          const SizedBox(height: 24),

          _PolicySection(
            title: '1. Overview',
            text:
            'Streak Flow is a habit tracking application designed to help you build and maintain positive habits through streaks, statistics, achievements, reminders, and progress tracking.',
          ),

          _PolicySection(
            title: '2. Data Storage',
            text:
            'Your habit data, activity history, profile information, statistics, and application preferences are stored locally on your device.',
          ),

          _PolicySection(
            title: '3. Personal Information',
            text:
            'Streak Flow does not require you to create an account and does not ask for your name, email address, or other contact details. Your habits, streaks, statistics, and profile information stay on your device and are never shared with advertisers.'
            '\n\n'
            'The free version of Streak Flow displays ads. The advertising service we use may collect certain device and usage information, as described in Section 6.',
          ),

          _PolicySection(
            title: '4. Notifications',
            text:
            'If you enable reminders, Streak Flow may schedule notifications on your device to remind you about your habits. Notifications can be disabled through the application settings or your device settings.',
          ),

          _PolicySection(
            title: '5. Backup and Restore',
            text:
            'When you use Backup & Restore, the application creates a backup file containing the data necessary to restore your application information. The backup is shared or stored only when you explicitly initiate the export or import process.',
          ),

          _PolicySection(
            title: '6. Advertising and Third-Party Services',
            text:
            'Streak Flow displays ads using Google AdMob, a service provided by Google. To show ads, measure their performance, and prevent fraud, Google may collect and process information such as:'
            '\n\n'
            "• your device's advertising identifier (for example, the Android Advertising ID);\n"
            '• your IP address and approximate location derived from it;\n'
            '• device and app information, such as device model, operating system, app version, and language;\n'
            '• ad interaction data, such as which ads were shown or tapped;\n'
            '• diagnostic and performance data.'
            '\n\n'
            'Depending on your consent choices, Google may use this information to show personalized or non-personalized ads. Streak Flow does not send your habits, streaks, statistics, or profile information to Google or any advertiser.'
            '\n\n'
            "Google's use of this information is governed by the Google Privacy Policy (https://policies.google.com/privacy). You can learn how Google uses information from apps that use its services at https://policies.google.com/technologies/partner-sites."
            '\n\n'
            'The application also uses platform services and libraries for features such as notifications, file sharing, and app reviews. These services may process information according to their own privacy policies.',
          ),

          _PolicySection(
            title: '7. Your Advertising Choices',
            text:
            "• Consent: Where required by law (for example, in the European Economic Area, the United Kingdom, Switzerland, and certain US states), Streak Flow shows Google's consent message before personalized ads are served. You can accept, reject, or manage your choices.\n"
            '• Changing your choices: Where applicable, you can review or change your choices at any time in Settings → Legal & Privacy → Ad Privacy Choices.\n'
            '• Advertising ID: On Android, you can reset or delete your advertising ID in your device settings (usually Settings → Google → Ads, or Settings → Privacy → Ads).\n'
            '• Offline use: Streak Flow works fully without an internet connection. No ads are requested while your device is offline.',
          ),

          _PolicySection(
            title: "8. Children's Privacy",
            text:
            'Streak Flow is not directed at children under the age of 13, and we do not knowingly collect personal information from children under 13.',
          ),

          _PolicySection(
            title: '9. Data Security',
            text:
            'Because your habit data is stored locally, you are responsible for protecting access to your device and any exported backup files.',
          ),

          _PolicySection(
            title: '10. Changes to This Policy',
            text:
            'This Privacy Policy may be updated from time to time. Any updated version will be made available within the application.',
          ),

          _PolicySection(
            title: '11. Contact',
            text:
            'If you have questions or concerns about this Privacy Policy or advertising in Streak Flow, contact us at support@codesapience.com or visit https://codesapience.com.',
          ),

          const SizedBox(height: 24),

          Text(
            'Streak Flow',
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