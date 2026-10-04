class OnboardingData {
  const OnboardingData({
    required this.name,
    required this.goals,
    required this.notificationsEnabled,
    required this.completed,
    this.selectedSuggestionIds = const <String>{},
  });

  final String name;

  final List<String> goals;

  final bool notificationsEnabled;

  final bool completed;

  /// Ids of the suggested habits picked on the "Start with a few
  /// habits" step; they are created when onboarding finishes.
  final Set<String> selectedSuggestionIds;

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
    Set<String>? selectedSuggestionIds,
  }) {
    return OnboardingData(
      name: name ?? this.name,
      goals: goals ?? this.goals,
      notificationsEnabled:
      notificationsEnabled ??
          this.notificationsEnabled,
      completed: completed ?? this.completed,
      selectedSuggestionIds:
      selectedSuggestionIds ?? this.selectedSuggestionIds,
    );
  }
}
