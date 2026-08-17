import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_theme_mode.dart';
import '../../domain/models/user_profile.dart';

import 'profile_providers.dart';

class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    return ref.read(
      profileRepositoryProvider,
    ).getProfile();
  }

  Future<void> updateProfile(
      UserProfile profile,
      ) async {
    state = const AsyncLoading();

    await ref.read(
      profileRepositoryProvider,
    ).saveProfile(
      profile,
    );

    state = AsyncData(
      profile,
    );
  }

  Future<void> completeOnboarding({
    required String name,
    required List<String> goals,
    required bool notificationsEnabled,
  }) async {
    final profile = UserProfile(
      name: name,
      goals: goals,
      notificationsEnabled: notificationsEnabled,
      onboardingCompleted: true,
      themeMode: AppThemeMode.system,
    );

    await ref.read(
      profileRepositoryProvider,
    ).saveProfile(
      profile,
    );

    state = AsyncData(
      profile,
    );
  }

  Future<void> updateTheme(
      AppThemeMode themeMode,
      ) async {
    final currentProfile = state.value;

    if (currentProfile == null) {
      return;
    }

    final updatedProfile = currentProfile.copyWith(
      themeMode: themeMode,
    );

    await ref
        .read(
      profileRepositoryProvider,
    )
        .saveProfile(
      updatedProfile,
    );

    state = AsyncData(
      updatedProfile,
    );
  }

  Future<void> resetOnboarding() async {
    await ref.read(
      profileRepositoryProvider,
    ).saveProfile(
      UserProfile.empty,
    );

    state = AsyncData(
      UserProfile.empty,
    );
  }
}

final profileProvider = AsyncNotifierProvider<
    ProfileNotifier,
    UserProfile>(
  ProfileNotifier.new,
);