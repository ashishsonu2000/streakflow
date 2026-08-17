import '../../domain/models/user_profile.dart';

abstract class ProfileLocalDatasource {
  Future<UserProfile> getProfile();

  Future<void> saveProfile(
      UserProfile profile,
      );
}


