import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/analytics/analytics_grid.dart';
import '../../../core/ui/dashboard/dashboard_header.dart';
import '../../../core/ui/design/app_breakpoints.dart';
import '../../../core/ui/design/app_spacing.dart';
import '../../../core/ui/layouts/responsive_dashboard.dart';
import '../../../core/ui/feedback/feedback_service.dart';
import '../../../core/ui/animations/celebration_screen.dart';

import '../../../shell/presentation/provider/navigation_provider.dart';
import '../../calendar/presentation/providers/calendar_provider.dart';

import '../../habits/presentation/providers/habit_command_provider.dart';
import '../domain/models/dashboard_view_model.dart';

import '../presentation/providers/dashboard_provider.dart';
import '../presentation/providers/streak_risk_provider.dart';
import '../presentation/widgets/activity/recent_activity.dart';
import '../presentation/widgets/calendar/mini_calendar.dart';
import '../presentation/widgets/hero/hero_card.dart';
import '../presentation/widgets/recovery/streak_recovery_card.dart';
import '../presentation/widgets/today/today_habits_section.dart';
import '../presentation/widgets/weekly/dashboard_weekly_progress_card.dart';

import 'insights/dashboard_insights.dart';


class _EmptyDashboardBadge extends StatelessWidget {
  const _EmptyDashboardBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF172B4D).withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: const Color(0xFF172B4D),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF34445C),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardBody extends ConsumerStatefulWidget {
  const DashboardBody({
    super.key,
    required this.dashboard,
  });

  final DashboardViewModel dashboard;

  @override
  ConsumerState<DashboardBody> createState() =>
      _DashboardBodyState();
}

class _DashboardBodyState
    extends ConsumerState<DashboardBody> {
  int? _previousLevel;

  @override
  void initState() {
    super.initState();

    _previousLevel =
        widget.dashboard.hero.level;
  }

  @override
  void didUpdateWidget(
      covariant DashboardBody oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    final newLevel =
        widget.dashboard.hero.level;

    if (_previousLevel != null &&
        newLevel > _previousLevel!) {
      _triggerLevelUp(newLevel);
    }

    _previousLevel = newLevel;
  }

  // ===============================================================
  // LEVEL UP
  // ===============================================================

  void _triggerLevelUp(int level) {
    FeedbackService.playLevelUpSound();
    FeedbackService.heavyImpact();
    FeedbackService.celebrate();

    if (!mounted) {
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(
          alpha: 0.5,
        ),
        pageBuilder: (_, __, ___) {
          return CelebrationScreen(
            level: level,
          );
        },
      ),
    );
  }

  // ===============================================================
  // COMPLETE / UNDO HABIT
  // ===============================================================

  Future<void> _toggleHabit(
      String habitId,
      bool completed,
      ) async {
    try {
      final commandNotifier =
      ref.read(
        habitCommandNotifierProvider.notifier,
      );

      if (completed) {
        await commandNotifier.uncompleteHabit(
          habitId,
        );
      } else {
        await commandNotifier.completeHabit(
          habitId,
        );
      }

      // Refresh dashboard data.
      ref.invalidate(
        dashboardProvider,
      );

      // Keep calendar in sync.
      ref.invalidate(
        calendarProvider,
      );
    } catch (error, stack) {
      debugPrint(
        'Failed to toggle habit: $error',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to update habit',
          ),
        ),
      );
    }
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final dashboard = widget.dashboard;

    final riskyHabit = ref.watch(
      streakRiskProvider,
    );

    debugPrint(
      'Risky habit: ${riskyHabit?.title}',
    );

    // =============================================================
    // EMPTY DASHBOARD
    // =============================================================

    if (dashboard.sections.todayHabits.isEmpty) {
      return SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF9FBFF),
                Color(0xFFEAF1F8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Soft decorative navy glow.
              Positioned(
                top: -110,
                right: -90,
                child: IgnorePointer(
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF172B4D).withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 48),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Brand mark.
                        Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.88),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF172B4D)
                                    .withValues(alpha: 0.10),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/branding/app_icon.png',
                            width: 60,
                            height: 50,
                            fit: BoxFit.fill,
                          ),

                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'Welcome to Streak Flow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                            color: Color(0xFF12213A),
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Create your first habit and start building '
                                'a streak that keeps you moving forward.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.55,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF52627A),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Small value-proposition chips.
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            _EmptyDashboardBadge(
                              icon: Icons.local_fire_department_rounded,
                              label: 'Build streaks',
                            ),
                            _EmptyDashboardBadge(
                              icon: Icons.insights_rounded,
                              label: 'Track progress',
                            ),
                            _EmptyDashboardBadge(
                              icon: Icons.emoji_events_rounded,
                              label: 'Reach goals',
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Navy / indigo gradient CTA with white highlight.
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF172B4D),
                                  Color(0xFF4F46E5),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF172B4D),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  ref
                                      .read(
                                    navigationProvider.notifier,
                                  )
                                      .goHabits();
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                          size: 21,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Create Your First Habit',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 1,
                                      left: 22,
                                      right: 22,
                                      child: IgnorePointer(
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(99),
                                            color: Colors.black
                                                .withValues(alpha: 0.28),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        const Text(
                          'Start small. Stay consistent. Let your streak grow.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // =============================================================
    // DASHBOARD
    // =============================================================

    return SafeArea(
      child: Container(
        color: const Color(0xFFEAF0F6),
        child: SingleChildScrollView(
          physics:
          const ClampingScrollPhysics(),
          padding:
          const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
            32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth:
                AppBreakpoints
                    .largeDesktop,
              ),
              child: ResponsiveDashboard(
                // ===================================================
                // HEADER
                // ===================================================

                header: DashboardHeader(
                  greeting:
                  dashboard.user.greeting,
                  userName:
                  dashboard.user.userName,
                ),

                // ===================================================
                // HERO
                // ===================================================

                hero: HeroCard(
                  hero: dashboard.hero,
                  user: dashboard.user,
                ),

                // ===================================================
                // STREAK RECOVERY
                // ===================================================

                recovery: riskyHabit == null
                    ? const SizedBox()
                    : StreakRecoveryCard(
                  habit: riskyHabit,
                ),

                // ===================================================
                // ANALYTICS
                // ===================================================

                analytics: AnalyticsGrid(
                  analytics:
                  dashboard
                      .analyticsCards,
                ),

                // ===================================================
                // TODAY'S HABITS
                // ===================================================

                habits: TodayHabitsSection(
                  habits: dashboard
                      .sections
                      .todayHabits,

                  onHabitTap: (habit) {
                    context.pushNamed(
                      'habit-detail',
                      pathParameters: {
                        'id': habit.id,
                      },
                    );
                  },

                  onHabitToggle:
                      (habit) async {
                    await _toggleHabit(
                      habit.id,
                      habit.completed,
                    );
                  },
                ),

                // ===================================================
                // CALENDAR
                // ===================================================

                calendar: MiniCalendar(
                  calendar:
                  dashboard.calendar,
                  onTap: (date) async {
                    await ref
                        .read(
                      calendarProvider
                          .notifier,
                    )
                        .openDate(date);

                    ref
                        .read(
                      navigationProvider
                          .notifier,
                    )
                        .goCalendar();
                  },
                ),

                // ===================================================
                // WEEKLY PROGRESS
                // ===================================================

                weekly:
                DashboardWeeklyProgressCard(
                  weekly: dashboard
                      .sections
                      .weeklyProgress,
                ),

                // ===================================================
                // RECENT ACTIVITY
                // ===================================================

                activity: RecentActivity(
                  activities: dashboard
                      .sections
                      .activities,
                ),

                // ===================================================
                // INSIGHTS
                // ===================================================

                insights: DashboardInsights(
                  insights: dashboard
                      .sections
                      .insights,
                ),

                // ===================================================
                // QUICK ACTIONS REMOVED
                // ===================================================

                // actions: QuickActions(
                //   actions:
                //       dashboard.sections.actions,
                //   onActionTap: (action) {
                //     debugPrint(
                //       action.title,
                //     );
                //   },
                // ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}