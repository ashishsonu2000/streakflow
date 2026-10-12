import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/feedback_service.dart';
import '../providers/feedback_prompt_provider.dart';

/// Opens the feedback email, or explains how to reach us when no email
/// app is installed.
Future<bool> sendFeedback(BuildContext context) async {
  final sent = await FeedbackEmailService().send();

  if (!sent && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No email app found. Write to contact@codesapience.com',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  return sent;
}

/// Dashboard card asking for feedback. Shown by [feedbackPromptProvider].
class FeedbackPromptCard extends ConsumerWidget {
  const FeedbackPromptCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(feedbackPromptProvider)) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 4, 8),
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: colors.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How is Streak Flow working for you?',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tell me one thing you would change or fix. '
                        'I read every message and use it in the next update.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Not now',
                  icon: const Icon(Icons.close_rounded),
                  color: colors.onPrimaryContainer,
                  onPressed: () {
                    ref.read(feedbackPromptProvider.notifier).snooze();
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton.tonal(
                  onPressed: () async {
                    final sent = await sendFeedback(context);
                    if (sent) {
                      await ref
                          .read(feedbackPromptProvider.notifier)
                          .snooze();
                    }
                  },
                  child: const Text('Send feedback'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
