import 'app_theme_mode.dart';

class UserProfile {
  const UserProfile({
    required this.name,
    required this.notificationsEnabled,
    required this.onboardingCompleted,
    required this.goals,
    required this.themeMode,
  });

  final String name;

  final bool notificationsEnabled;

  final bool onboardingCompleted;

  final List<String> goals;

  final AppThemeMode themeMode;

  static const empty = UserProfile(
    name: '',
    notificationsEnabled: false,
    onboardingCompleted: false,
    goals: [],
    themeMode: AppThemeMode.system,
  );

  UserProfile copyWith({
    String? name,
    bool? notificationsEnabled,
    bool? onboardingCompleted,
    List<String>? goals,
    AppThemeMode? themeMode,
  }) {
    return UserProfile(
      name: name ?? this.name,
      notificationsEnabled:
      notificationsEnabled ??
          this.notificationsEnabled,
      onboardingCompleted:
      onboardingCompleted ??
          this.onboardingCompleted,
      goals: goals ?? this.goals,
      themeMode:
      themeMode ?? this.themeMode,
    );
  }
}