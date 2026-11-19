import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'attendance_history_state.dart';

class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  final AttendanceRepository _repository;
  final ConnectivityService _connectivityService;

  AttendanceHistoryCubit({
    required AttendanceRepository repository,
    required ConnectivityService connectivityService,
  })  : _repository = repository,
        _connectivityService = connectivityService,
        super(const AttendanceHistoryInitial());

  Future<void> loadHistory({
    required String employeeId,
    String? month,
  }) async {
    emit(const AttendanceHistoryLoading());

    final selectedMonth = month ?? DateFormat('yyyy-MM').format(DateTime.now());
    final isConnected = await _connectivityService.isConnected;

    try {
      final records = await _repository.getAttendanceHistory(
        employeeId,
        selectedMonth,
      );

      emit(AttendanceHistoryLoaded(
        records: records,
        selectedMonth: selectedMonth,
        isOffline: !isConnected,
      ));
    } catch (e) {
      emit(AttendanceHistoryError(e.toString()));
    }
  }

  void changeMonth({
    required String employeeId,
    required String month,
  }) {
    loadHistory(employeeId: employeeId, month: month);
  }
}
