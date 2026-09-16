import 'package:go_router/go_router.dart';

import '../features/achievements/presentation/pages/achievement_tester_page.dart';
import '../features/achievements/presentation/pages/achievements_page.dart';

import '../features/backup/presentation/pages/backup_page.dart';

import '../features/calendar/presentation/pages/calendar_page.dart';

import '../features/habits/domain/models/habit.dart';
import '../features/habits/domain/models/habit_form_arguments.dart';

import '../features/habits/presentation/pages/archived_habits_page.dart';
import '../features/habits/presentation/pages/habit_detail_page.dart';
import '../features/habits/presentation/pages/habit_form_page.dart';
import '../features/habits/presentation/pages/habit_history_page.dart';

import '../features/habits/presentation/pages/habit_statistics_page.dart';
import '../features/notifications/presentation/pages/notification_settings_page.dart';
import '../features/notifications/presentation/pages/notification_test_page.dart';

import '../features/onboarding/presentation/pages/onboarding_page.dart';

import '../features/profile/presentation/pages/app_start_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';

import '../features/settings/presentation/pages/about_page.dart';
import '../features/settings/presentation/pages/privacy_policy_page.dart';
import '../features/settings/presentation/pages/terms_page.dart';

import '../presentation/splash/post_splash_animation.dart';
import '../shell/presentation/pages/main_shell.dart';

import 'routes.dart';

final router = GoRouter(
  // ===========================================================
  // APP STARTUP
  // ===========================================================

  initialLocation: '/splash',

  routes: [
    // =========================================================
    // SPLASH
    // =========================================================

    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) {
        return PostSplashAnimation(
          onFinished: () {
            context.go(
              AppRoutes.appStart,
            );
          },
        );
      },
    ),

    // =========================================================
    // APP START
    // =========================================================

    GoRoute(
      path: AppRoutes.appStart,
      name: 'app-start',
      builder: (_, __) {
        return const AppStartPage();
      },
    ),

    // =========================================================
    // HOME / DASHBOARD
    // =========================================================

    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (
          context,
          state,
          ) {
        return const MainShell();
      },
    ),

    // =========================================================
    // CALENDAR
    // =========================================================

    GoRoute(
      path: AppRoutes.calendar,
      name: 'calendar',
      builder: (
          context,
          state,
          ) {
        return const CalendarPage();
      },
    ),

    // =========================================================
// HABITS
// =========================================================

    GoRoute(
      path: AppRoutes.habitForm,
      name: 'habit-form',
      builder: (
          context,
          state,
          ) {
        final arguments =
        state.extra as HabitFormArguments?;

        return HabitFormPage(
          arguments: arguments,
        );
      },
    ),

// =========================================================
// HABIT DETAIL
// =========================================================

    GoRoute(
      path: AppRoutes.habitDetail,
      name: 'habit-detail',
      builder: (
          context,
          state,
          ) {
        final id =
        state.pathParameters['id']!;

        return HabitDetailPage(
          habitId: id,
        );
      },
    ),

// =========================================================
// HABIT STATISTICS
// =========================================================

    GoRoute(
      path: '/habits/:id/statistics',
      name: 'habit-statistics',
      builder: (
          context,
          state,
          ) {
        final habitId =
        state.pathParameters['id']!;

        final habit =
        state.extra as Habit?;

        return HabitStatisticsPage(
          habitId: habitId,
          habitTitle:
          habit?.title ?? 'Habit Statistics',
        );
      },
    ),

// =========================================================
// ARCHIVED HABITS
// =========================================================

    GoRoute(
      path: AppRoutes.archivedHabits,
      name: 'archived-habits',
      builder: (
          _,
          __,
          ) {
        return const ArchivedHabitsPage();
      },
    ),

// =========================================================
// HABIT HISTORY
// =========================================================

    GoRoute(
      name: 'habit-history',
      path: '/habits/:id/history',
      builder: (
          context,
          state,
          ) {
        final habit =
        state.extra as Habit;

        return HabitHistoryPage(
          habitId: habit.id,
          habitTitle: habit.title,
        );
      },
    ),

    // =========================================================
// HABIT STATISTICS
// =========================================================



    // =========================================================
    // ACHIEVEMENTS
    // =========================================================

    GoRoute(
      path: AppRoutes.achievements,
      name: 'achievements',
      builder: (
          _,
          __,
          ) {
        return const AchievementsPage();
      },
    ),

    // =========================================================
    // ACHIEVEMENT TESTER
    // =========================================================

    GoRoute(
      path: AppRoutes.achievementTester,
      name: 'achievement-tester',
      builder: (
          _,
          __,
          ) {
        return const AchievementTesterPage();
      },
    ),

    // =========================================================
    // PROFILE
    // =========================================================

    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (
          _,
          __,
          ) {
        return const ProfilePage();
      },
    ),

    // =========================================================
    // ONBOARDING
    // =========================================================

    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (
          _,
          __,
          ) {
        return const OnboardingPage();
      },
    ),

    // =========================================================
    // EDIT PROFILE
    // =========================================================

    GoRoute(
      path: AppRoutes.editProfile,
      name: 'edit-profile',
      builder: (
          _,
          __,
          ) {
        return const EditProfilePage();
      },
    ),

    // =========================================================
    // SETTINGS
    // =========================================================

    // ---------------------------------------------------------
    // ABOUT
    // ---------------------------------------------------------

    GoRoute(
      path: AppRoutes.about,
      name: 'about',
      builder: (
          context,
          state,
          ) {
        return const AboutPage();
      },
    ),

    // ---------------------------------------------------------
    // BACKUP
    // ---------------------------------------------------------

    GoRoute(
      path: AppRoutes.backup,
      name: 'backup',
      builder: (
          _,
          __,
          ) {
        return const BackupPage();
      },
    ),

    // ---------------------------------------------------------
    // NOTIFICATION SETTINGS
    // ---------------------------------------------------------

    GoRoute(
      path: AppRoutes.notification,
      name: 'notification',
      builder: (
          _,
          __,
          ) {
        return const NotificationSettingsPage();
      },
    ),

    // ---------------------------------------------------------
    // NOTIFICATION TEST
    // ---------------------------------------------------------

    GoRoute(
      path: '/notification-test',
      name: 'notification-test',
      builder: (
          _,
          __,
          ) {
        return const NotificationTestPage();
      },
    ),

    // ---------------------------------------------------------
    // PRIVACY
    // ---------------------------------------------------------

    GoRoute(
      path: AppRoutes.privacy,
      name: 'privacy',
      builder: (
          context,
          state,
          ) {
        return const PrivacyPolicyPage();
      },
    ),

    // ---------------------------------------------------------
    // TERMS
    // ---------------------------------------------------------

    GoRoute(
      path: AppRoutes.terms,
      name: 'terms',
      builder: (
          context,
          state,
          ) {
        return const TermsPage();
      },
    ),
  ],
);