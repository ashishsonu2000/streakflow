import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';

import '../../domain/usecases/reset_application_usecase.dart';

final resetApplicationProvider =
Provider<ResetApplicationUseCase>(
      (ref) {
    return ResetApplicationUseCase(
      ref.read(
        habitRepositoryProvider,
      ),
    );
  },
);