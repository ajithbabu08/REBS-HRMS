import 'package:intl/intl.dart';

import '../../../../core/network/connectivity_service.dart';
import '../datasources/leave_local_datasource.dart';
import '../datasources/leave_remote_datasource.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/repositories/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveLocalDataSource _localDataSource;
  final LeaveRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;

  LeaveRepositoryImpl({
    required LeaveLocalDataSource localDataSource,
    required LeaveRemoteDataSource remoteDataSource,
    required ConnectivityService connectivityService,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _connectivityService = connectivityService;

  @override
  Future<LeaveBalance> getLeaveBalance(String employeeId) async {
    final isConnected = await _connectivityService.isConnected;
    if (isConnected) {
      try {
        final remoteBalance = await _remoteDataSource
            .getLeaveBalance()
            .timeout(const Duration(seconds: 3));
        await _localDataSource.saveBalance(employeeId, remoteBalance);
        return remoteBalance;
      } catch (_) {
        // Fall back to cache
      }
    }

    final cached = await _localDataSource.getBalance(employeeId);
    return cached ?? const LeaveBalance(casual: 2, sick: 3);
  }

  @override
  Future<List<LeaveRequest>> getLeaveRequests(String employeeId) async {
    final isConnected = await _connectivityService.isConnected;
    if (isConnected) {
      try {
        final remoteRequests = await _remoteDataSource
            .getLeaveRequests()
            .timeout(const Duration(seconds: 3));
        await _localDataSource.replaceAllRequests(employeeId, remoteRequests);
        return remoteRequests;
      } catch (_) {
        // Fall back to cache
      }
    }

    return _localDataSource.getRequests(employeeId);
  }

  @override
  Stream<List<LeaveRequest>> watchLeaveRequests(String employeeId) {
    return _localDataSource.watchRequests(employeeId);
  }

  @override
  Future<LeaveRequest> submitLeaveRequest({
    required String employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    final fmt = DateFormat('yyyy-MM-dd');
    final submitted = await _remoteDataSource.submitLeaveRequest(
      employeeId: employeeId,
      leaveType: leaveType,
      startDate: fmt.format(startDate),
      endDate: fmt.format(endDate),
      reason: reason,
    );

    // Save to local cache
    await _localDataSource.insertRequest(submitted);

    // Refresh balance
    try {
      final balance = await _remoteDataSource.getLeaveBalance();
      await _localDataSource.saveBalance(employeeId, balance);
    } catch (_) {}

    return submitted;
  }

  @override
  Future<List<LeaveRequest>> getOverlappingLeaves({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _localDataSource.getOverlapping(
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
