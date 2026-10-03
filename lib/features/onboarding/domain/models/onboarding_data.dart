class OnboardingData {
  const OnboardingData({
    required this.name,
    required this.goals,
    required this.notificationsEnabled,
    required this.completed,
  });

  final String name;

  final List<String> goals;

  final bool notificationsEnabled;

  final bool completed;

  static const empty = OnboardingData(
    name: '',
    goals: [],
    notificationsEnabled: false,
    completed: false,
  );

  OnboardingData copyWith({
    String? name,
    List<String>? goals,
    bool? notificationsEnabled,
    bool? completed,
  }) {
    return OnboardingData(
      name: name ?? this.name,
      goals: goals ?? this.goals,
      notificationsEnabled:
      notificationsEnabled ??
          this.notificationsEnabled,
      completed: completed ?? this.completed,
    );
  }
}