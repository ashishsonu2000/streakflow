import 'package:streak_calculator_flutter/core/database/isar_service.dart';

import '../../../../core/database/collections/profile_collection.dart';

import '../../domain/models/app_theme_mode.dart';
import '../../domain/models/user_profile.dart';

import 'profile_local_datasource.dart';

class ProfileLocalDatasourceImpl
    implements ProfileLocalDatasource {
  @override
  Future<UserProfile> getProfile() async {
    final isar =
    await IsarService.instance.database;

    final profile =
    await isar.profileCollections.get(1);

    if (profile == null) {
      return UserProfile.empty;
    }

    final themeMode =
    AppThemeMode.values.firstWhere(
          (mode) => mode.name == profile.themeMode,
      orElse: () => AppThemeMode.system,
    );

    return UserProfile(
      name: profile.name,
      notificationsEnabled:
      profile.notificationsEnabled,
      onboardingCompleted:
      profile.onboardingCompleted,
      goals: profile.goals,
      themeMode: themeMode,
    );
  }

  @override
  Future<void> saveProfile(
      UserProfile profile,
      ) async {
    final isar =
    await IsarService.instance.database;

    final collection =
    ProfileCollection()
      ..id = 1
      ..name = profile.name
      ..notificationsEnabled =
          profile.notificationsEnabled
      ..onboardingCompleted =
          profile.onboardingCompleted
      ..goals = profile.goals
      ..themeMode =
          profile.themeMode.name;

    await isar.writeTxn(() async {
      await isar.profileCollections.put(
        collection,
      );
    });
  }
}