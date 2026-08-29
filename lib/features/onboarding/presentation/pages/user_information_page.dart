import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_theme.dart';

class UserInformationPage extends ConsumerWidget {
  const UserInformationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: OnboardingCard(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const OnboardingTitle(
                title: "What's your name?",
                subtitle: 'We’ll use it to make your journey feel personal.',
              ),
              const SizedBox(height: 26),
              TextField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Your name',
                  hintText: 'e.g. Ashish',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  labelStyle: const TextStyle(color: OnboardingColors.muted),
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  prefixIconColor: OnboardingColors.navy,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: OnboardingColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: OnboardingColors.navy, width: 1.5),
                  ),
                ),
                onChanged: (value) => ref.read(onboardingProvider.notifier).setName(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
