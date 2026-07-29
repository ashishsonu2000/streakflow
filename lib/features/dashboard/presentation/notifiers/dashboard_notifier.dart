import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/dashboard_view_model.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import '../providers/dashboard_provider.dart';

class DashboardNotifier extends AsyncNotifier<DashboardViewModel> {
  GetDashboardUseCase get _useCase => ref.read(getDashboardUseCaseProvider);

  @override
  Future<DashboardViewModel> build() {
    return _useCase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _useCase(),
    );
  }
}
