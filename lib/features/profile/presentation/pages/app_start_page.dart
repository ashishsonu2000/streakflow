import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shell/presentation/pages/main_shell.dart';

import '../../../onboarding/presentation/pages/onboarding_page.dart';

import '../providers/profile_provider.dart';

class AppStartPage
    extends ConsumerWidget {
  const AppStartPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final profile = ref.watch(
      profileProvider,
    );

    return profile.when(
      loading: () => const Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),
      data: (profile) {
        if (!profile
            .onboardingCompleted) {
          return const OnboardingPage();
        }

        return const MainShell();
      },
    );
  }
}