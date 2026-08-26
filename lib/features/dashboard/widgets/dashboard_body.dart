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
import '../../onboarding/presentation/widgets/first_habit_experience.dart';
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
          color: const Color(0xFFEAF0F6),
          child: Center(
            child: Padding(
              padding:
              const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons
                        .local_fire_department_rounded,
                    size: 72,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Text(
                    'Welcome to Streak Calculator',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                    textAlign:
                    TextAlign.center,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  const Text(
                    'Create your first habit to begin your streak journey.',
                    textAlign:
                    TextAlign.center,
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  FilledButton.icon(
                    onPressed: () {
                      ref
                          .read(
                        navigationProvider
                            .notifier,
                      )
                          .goHabits();
                    },
                    icon: const Icon(
                      Icons.add,
                    ),
                    label: const Text(
                      'Create First Habit',
                    ),
                  ),
                ],
              ),
            ),
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