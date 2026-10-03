import '../../domain/models/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasource/profile_local_datasource.dart';


class ProfileRepositoryImpl
    implements ProfileRepository {
  ProfileRepositoryImpl(
      this._datasource,
      );

  final ProfileLocalDatasource
  _datasource;

  @override
  Future<UserProfile> getProfile() {
    return _datasource.getProfile();
  }

  @override
  Future<void> saveProfile(
      UserProfile profile,
      ) {
    return _datasource.saveProfile(
      profile,
    );
  }
}