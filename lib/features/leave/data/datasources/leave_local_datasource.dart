import '../../../../core/database/dao/leave_dao.dart';
import '../models/leave_balance_model.dart';
import '../models/leave_request_model.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/entities/leave_request.dart';

abstract class LeaveLocalDataSource {
  Future<LeaveBalance?> getBalance(String employeeId);
  Future<void> saveBalance(String employeeId, LeaveBalance balance);
  Future<List<LeaveRequest>> getRequests(String employeeId);
  Stream<List<LeaveRequest>> watchRequests(String employeeId);
  Future<LeaveRequest> insertRequest(LeaveRequest request);
  Future<List<LeaveRequest>> getOverlapping({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<void> replaceAllRequests(
      String employeeId, List<LeaveRequest> requests);
}

class LeaveLocalDataSourceImpl implements LeaveLocalDataSource {
  final LeaveDao _leaveDao;

  LeaveLocalDataSourceImpl({required LeaveDao leaveDao}) : _leaveDao = leaveDao;

  @override
  Future<LeaveBalance?> getBalance(String employeeId) async {
    final entry = await _leaveDao.getBalance(employeeId);
    return entry != null ? LeaveBalanceModel.fromEntry(entry) : null;
  }

  @override
  Future<void> saveBalance(String employeeId, LeaveBalance balance) {
    return _leaveDao.upsertBalance(
      LeaveBalanceModel.toCompanion(employeeId, balance),
    );
  }

  @override
  Future<List<LeaveRequest>> getRequests(String employeeId) async {
    final entries = await _leaveDao.getRequests(employeeId);
    return entries.map(LeaveRequestModel.fromEntry).toList();
  }

  @override
  Stream<List<LeaveRequest>> watchRequests(String employeeId) {
    return _leaveDao
        .watchRequests(employeeId)
        .map((entries) => entries.map(LeaveRequestModel.fromEntry).toList());
  }

  @override
  Future<LeaveRequest> insertRequest(LeaveRequest request) async {
    final companion = LeaveRequestModel.toCompanion(request);
    final id = await _leaveDao.insertRequest(companion);
    return LeaveRequest(
      id: id,
      leaveRequestId: request.leaveRequestId,
      employeeId: request.employeeId,
      leaveType: request.leaveType,
      startDate: request.startDate,
      endDate: request.endDate,
      reason: request.reason,
      status: request.status,
      submittedAt: request.submittedAt,
      numberOfDays: request.numberOfDays,
    );
  }

  @override
  Future<List<LeaveRequest>> getOverlapping({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final entries = await _leaveDao.getOverlapping(
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
    );
    return entries.map(LeaveRequestModel.fromEntry).toList();
  }

  @override
  Future<void> replaceAllRequests(
      String employeeId, List<LeaveRequest> requests) {
    final companions = requests.map(LeaveRequestModel.toCompanion).toList();
    return _leaveDao.replaceAll(employeeId, companions);
  }
}
