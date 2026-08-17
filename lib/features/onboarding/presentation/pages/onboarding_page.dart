import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';

import '../../../profile/presentation/providers/profile_provider.dart';

import '../providers/onboarding_provider.dart';

import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_progress_indicator.dart';

import 'goal_selection_page.dart';
import 'notification_setup_page.dart';
import 'onboarding_complete_page.dart';
import 'user_information_page.dart';
import 'welcome_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  ConsumerState<OnboardingPage> createState() {
    return _OnboardingPageState();
  }
}

class _OnboardingPageState
    extends ConsumerState<OnboardingPage> {
  final _controller = PageController();

  int _page = 0;

  static const _pages = [
    WelcomePage(),
    UserInformationPage(),
    GoalSelectionPage(),
    NotificationSetupPage(),
    OnboardingCompletePage(),
  ];

  Future<void> _next() async {
    final isLastPage =
        _page == _pages.length - 1;

    if (!isLastPage) {
      await _controller.nextPage(
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeInOut,
      );

      return;
    }

    final onboarding = ref.read(
      onboardingProvider,
    );

    await ref
        .read(
      profileProvider.notifier,
    )
        .completeOnboarding(
      name: onboarding.name,
      goals: onboarding.goals,
      notificationsEnabled:
      onboarding.notificationsEnabled,
    );

    if (!mounted) {
      return;
    }

    context.go(
      AppRoutes.home,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingProgressIndicator(
              currentPage: _page,
              totalPages: _pages.length,
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics:
                const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _page = index;
                  });
                },
                children: _pages,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.all(
                24,
              ),
              child: OnboardingButton(
                label:
                _page ==
                    _pages.length -
                        1
                    ? 'Finish'
                    : 'Continue',
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}