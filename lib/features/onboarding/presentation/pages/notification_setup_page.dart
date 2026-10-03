import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_theme.dart';

class NotificationSetupPage extends ConsumerWidget {
  const NotificationSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(onboardingProvider).notificationsEnabled;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: OnboardingCard(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const OnboardingIconBadge(
                icon: Icons.notifications_active_rounded,
                size: 88,
              ),
              const SizedBox(height: 24),
              const OnboardingTitle(
                title: 'Daily reminders',
                subtitle: 'A gentle nudge can help you keep your streak alive.',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: OnboardingColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_none_rounded, color: OnboardingColors.navy),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Enable notifications',
                        style: TextStyle(
                          color: OnboardingColors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: enabled,
                      activeThumbColor: OnboardingColors.navy,
                      onChanged: (value) => ref.read(onboardingProvider.notifier).setNotifications(value),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
