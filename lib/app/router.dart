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
import '../shell/presentation/pages/main_shell.dart';

import 'routes.dart';

final router = GoRouter(
  initialLocation: AppRoutes.appStart,
  routes: [

    GoRoute(
      path: AppRoutes.appStart,
      name: 'app-start',
      builder: (_, __) {
        return const AppStartPage();
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (
          context,
          state,
          ) =>
      const MainShell(),
    ),

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

    GoRoute(
      path: AppRoutes.archivedHabits,
      name: 'archived-habits',
      builder: (
          _,
          __,
          ) =>
      const ArchivedHabitsPage(),
    ),

    GoRoute(
      path: AppRoutes.achievements,
      name: 'achievements',
      builder: (
          _,
          __,
          ) =>
      const AchievementsPage(),
    ),

    // =========================================================
    // Profile
    // =========================================================

    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (
          _,
          __,
          ) =>
      const ProfilePage(),
    ),

    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (
          _,
          __,
          ) =>
      const OnboardingPage(),
    ),

    GoRoute(
      path: AppRoutes.editProfile,
      name: 'edit-profile',
      builder: (_, __) {
        return const EditProfilePage();
      },
    ),

    GoRoute(
      path: AppRoutes.achievementTester,
      builder: (_, __) {
        return const AchievementTesterPage();
      },
    ),

    GoRoute(
      path: AppRoutes.about,
      builder: (
          context,
          state,
          ) {
        return const AboutPage();
      },
    ),
    GoRoute(
      path: '/notification-test',
      builder: (_, __) {
        return const NotificationTestPage();
      },
    ),

    GoRoute(
      path: AppRoutes.backup,
      builder: (_, __) {
        return const BackupPage();
      },
    ),

    GoRoute(
      path: AppRoutes.notification,
      builder: (_, __) {
        return const NotificationSettingsPage();
      },
    ),

    GoRoute(
      path: AppRoutes.privacy,
      builder: (
          context,
          state,
          ) {
        return const PrivacyPolicyPage();
      },
    ),

    GoRoute(
      path: AppRoutes.terms,
      builder: (
          context,
          state,
          ) {
        return const TermsPage();
      },
    ),

    GoRoute(
      name: 'habit-statistics',
      path: '/habits/:id/statistics',
      builder: (context, state) {
        final habit = state.extra as Habit;

        return HabitStatisticsPage(
          habitId: habit.id,
          habitTitle: habit.title,
        );
      },
    ),
  ],
);