import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../habits/presentation/provider/habit_providers.dart';

import '../../domain/builders/dashboard_summary_builder.dart';
import '../../domain/models/dashboard_view_model.dart';

import '../../domain/usecases/get_dashboard_usecase.dart';

///------------------------------------------------------------
/// UseCase Provider
///------------------------------------------------------------

final getDashboardUseCaseProvider = Provider<GetDashboardUseCase>((ref) {
  return GetDashboardUseCase(
    ref.read(habitRepositoryProvider),
    ref.read(getCalendarUseCaseProvider),
    DashboardSummaryBuilder(),
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
