import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../habits/presentation/provider/habit_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../statistics/presentation/provider/statistics_provider.dart';
import '../../domain/builders/dashboard_mapper.dart';
import '../../domain/models/dashboard_view_model.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

///------------------------------------------------------------
/// Dashboard Mapper
///------------------------------------------------------------

final dashboardMapperProvider = Provider<DashboardMapper>(
  (ref) => DashboardMapper(),
);

///------------------------------------------------------------
/// UseCase
///------------------------------------------------------------

final getDashboardUseCaseProvider = Provider<GetDashboardUseCase>((ref) {
  return GetDashboardUseCase(
    ref.read(getStatisticsUseCaseProvider),
    ref.read(dashboardMapperProvider),
    ref.read(getCalendarUseCaseProvider),
    ref.read(habitRepositoryProvider),
    ref.read(profileRepositoryProvider),
  );
});

///------------------------------------------------------------
/// Dashboard Notifier
///------------------------------------------------------------

class DashboardNotifier extends AsyncNotifier<DashboardViewModel> {
  GetDashboardUseCase get _useCase => ref.read(getDashboardUseCaseProvider);

  @override
  Future<DashboardViewModel> build() async {
    return _useCase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      _useCase.call,
    );
  }
}

///------------------------------------------------------------
/// Provider
///------------------------------------------------------------

final dashboardProvider =
AsyncNotifierProvider<DashboardNotifier, DashboardViewModel>(
  DashboardNotifier.new,
);
