import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/profile_local_datasource.dart';

import '../../data/datasource/profile_local_datasource_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';

import '../../domain/repositories/profile_repository.dart';

final profileLocalDatasourceProvider =
Provider<ProfileLocalDatasource>(
      (ref) {
    return ProfileLocalDatasourceImpl();
  },
);

final profileRepositoryProvider =
Provider<ProfileRepository>(
      (ref) {
    return ProfileRepositoryImpl(
      ref.read(
        profileLocalDatasourceProvider,
      ),
    );
  },
);