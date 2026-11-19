import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;
  StreamSubscription? _subscription;

  DashboardCubit({required DashboardRepository repository})
      : _repository = repository,
        super(const DashboardInitial());

  Future<void> loadDashboard({
    required String employeeId,
    String? todayDate,
  }) async {
    final date = todayDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 1. Instant load from local cache (<5ms)
    try {
      final cachedData =
          await _repository.getLocalDashboardData(employeeId, date);
      emit(DashboardLoaded(cachedData));
    } catch (_) {
      // In unlikely event local read fails, emit loading
      emit(const DashboardLoading());
    }

    // 2. Listen for local reactive updates (check-ins, check-outs, sync transitions)
    await _subscription?.cancel();
    _subscription = _repository
        .watchDashboardData(employeeId, date)
        .listen((updatedData) {
      if (!isClosed) {
        emit(DashboardLoaded(updatedData));
      }
    });

    // 3. Background refresh from remote API (non-blocking)
    try {
      final refreshed =
          await _repository.refreshDashboardData(employeeId, date);
      if (refreshed != null && !isClosed) {
        emit(DashboardLoaded(refreshed));
      }
    } catch (_) {
      // Silently keep cached data if remote call times out or errors
    }
  }

  void refresh({
    required String employeeId,
    String? todayDate,
  }) {
    loadDashboard(employeeId: employeeId, todayDate: todayDate);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
