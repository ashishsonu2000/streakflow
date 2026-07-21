import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';

class DashboardNotifier extends AsyncNotifier<DashboardSummary> {
  late GetDashboardSummaryUseCase _useCase;

  @override
  Future<DashboardSummary> build() async {
    _useCase = ref.read(
      getDashboardSummaryUseCaseProvider,
    );

    return _useCase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      _useCase.call,
    );
  }
}
