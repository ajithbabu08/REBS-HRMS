import '../entities/leave_balance.dart';
import '../entities/leave_request.dart';

abstract class LeaveRepository {
  Future<LeaveBalance> getLeaveBalance(String employeeId);
  Future<List<LeaveRequest>> getLeaveRequests(String employeeId);
  Stream<List<LeaveRequest>> watchLeaveRequests(String employeeId);
  Future<LeaveRequest> submitLeaveRequest({
    required String employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  });
  Future<List<LeaveRequest>> getOverlappingLeaves({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<void> resetLeaveData(String employeeId);
}
