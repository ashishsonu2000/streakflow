import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Terms & Conditions',
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

          _TermsSection(
            title: '1. Acceptance',
            text:
            'By using Streak Calculator, you agree to these Terms & Conditions. If you do not agree with these terms, please discontinue use of the application.',
          ),

          _TermsSection(
            title: '2. Use of the Application',
            text:
            'Streak Calculator is provided as a personal habit tracking and productivity tool. You agree to use the application only for lawful purposes.',
          ),

          _TermsSection(
            title: '3. Your Data',
            text:
            'You are responsible for the information and content you enter into the application and for maintaining appropriate backups of your data.',
          ),

          _TermsSection(
            title: '4. Notifications',
            text:
            'Reminder notifications are provided as a convenience. Notification delivery may depend on your device, operating system, battery settings, permissions, and other system conditions.',
          ),

          _TermsSection(
            title: '5. Backup Files',
            text:
            'You are responsible for protecting exported backup files. Streak Calculator is not responsible for loss or unauthorized access to backup files after they have been exported or shared.',
          ),

          _TermsSection(
            title: '6. Application Availability',
            text:
            'We may modify, improve, suspend, or discontinue parts of the application when necessary.',
          ),

          _TermsSection(
            title: '7. Disclaimer',
            text:
            'Streak Calculator is a productivity and habit tracking application. It does not provide medical, psychological, financial, or professional advice.',
          ),

          _TermsSection(
            title: '8. Changes to These Terms',
            text:
            'These Terms & Conditions may be updated from time to time. Continued use of the application after changes are published constitutes acceptance of the updated terms.',
          ),

          _TermsSection(
            title: '9. Contact',
            text:
            'For questions regarding these Terms & Conditions, please contact CodeSapience at support@codesapience.com.\n\n'
                'Website: codesapience.com',
          ),

          const SizedBox(height: 24),

          Text(
            'Streak Calculator',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Published by CodeSapience',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({
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