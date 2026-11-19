import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/repositories/leave_repository.dart';
import 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  final LeaveRepository _repository;
  final ConnectivityService _connectivityService;

  LeaveCubit({
    required LeaveRepository repository,
    required ConnectivityService connectivityService,
  })  : _repository = repository,
        _connectivityService = connectivityService,
        super(const LeaveInitial());

  Future<void> loadLeaveData(String employeeId) async {
    emit(const LeaveLoading());

    try {
      final isConnected = await _connectivityService.isConnected;
      final balance = await _repository.getLeaveBalance(employeeId);
      final requests = await _repository.getLeaveRequests(employeeId);

      emit(LeaveLoaded(
        balance: balance,
        requests: requests,
        isOffline: !isConnected,
      ));
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }

  void refresh(String employeeId) => loadLeaveData(employeeId);
}
