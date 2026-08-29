import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_progress_indicator.dart';
import '../widgets/onboarding_theme.dart';
import 'goal_selection_page.dart';
import 'notification_setup_page.dart';
import 'onboarding_complete_page.dart';
import 'user_information_page.dart';
import 'welcome_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();

  int _page = 0;

  late final AnimationController _animationController;

  static const _pages = [
    WelcomePage(),
    UserInformationPage(),
    GoalSelectionPage(),
    NotificationSetupPage(),
    OnboardingCompletePage(),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  Future<void> _next() async {
    final isLastPage = _page == _pages.length - 1;

    if (!isLastPage) {
      await _controller.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );

      return;
    }

    final onboarding = ref.read(onboardingProvider);

    await ref.read(profileProvider.notifier).completeOnboarding(
      name: onboarding.name,
      goals: onboarding.goals,
      notificationsEnabled: onboarding.notificationsEnabled,
    );

    if (!mounted) return;

    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: OnboardingColors.page,
      body: SafeArea(
        child: OnboardingBackground(
          child: Column(
            children: [
              // --------------------------------------------------
              // Top branding / progress area
              // --------------------------------------------------

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  16,
                  24,
                  8,
                ),
                child: Column(
                  children: [
                    _buildBrandHeader(),

                    const SizedBox(height: 18),

                    OnboardingProgressIndicator(
                      currentPage: _page,
                      totalPages: _pages.length,
                    ),
                  ],
                ),
              ),

              // --------------------------------------------------
              // Onboarding pages
              // --------------------------------------------------

              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _page = index;
                    });

                    _animationController
                      ..reset()
                      ..forward();
                  },
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOut,
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.035, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: _pages[index],
                      ),
                    );
                  },
                ),
              ),

              // --------------------------------------------------
              // Bottom action
              // --------------------------------------------------

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  8,
                  24,
                  22,
                ),
                child: _buildBottomAction(
                  isLastPage: isLastPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BRAND HEADER
  // ============================================================

  Widget _buildBrandHeader() {
    return Row(
      children: [
        // Logo
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/branding/app_icon.png',
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 12),

        // Brand name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
                children: [
                  TextSpan(
                    text: 'STREAK ',
                    style: TextStyle(
                      color: Color(0xFF102044),
                    ),
                  ),
                  TextSpan(
                    text: 'FLOW',
                    style: TextStyle(
                      color: Color(0xFF1677FF),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            Text(
              'Small steps. Big change.',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black.withValues(alpha: 0.48),
              ),
            ),
          ],
        ),

        const Spacer(),

        // Step counter
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF1677FF).withValues(alpha: 0.10),
            ),
          ),
          child: Text(
            '${_page + 1}/${_pages.length}',
            style: const TextStyle(
              color: Color(0xFF102044),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM ACTION
  // ============================================================

  Widget _buildBottomAction({
    required bool isLastPage,
  }) {
    return Column(
      children: [
        // Small motivational text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            isLastPage
                ? 'You are ready to build your streak.'
                : 'Build better habits, one day at a time.',
            key: ValueKey(isLastPage),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.48),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Existing reusable onboarding button
        OnboardingButton(
          label: isLastPage ? 'Start My Streak' : 'Continue',
          icon: Icons.arrow_forward_rounded,
          onPressed: _next,
        ),
      ],
    );
  }
}