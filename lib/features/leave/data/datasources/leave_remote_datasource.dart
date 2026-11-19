import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/leave_balance_model.dart';
import '../models/leave_request_model.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/entities/leave_request.dart';

abstract class LeaveRemoteDataSource {
  Future<LeaveBalance> getLeaveBalance();
  Future<List<LeaveRequest>> getLeaveRequests();
  Future<LeaveRequest> submitLeaveRequest({
    required String employeeId,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
  });
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final DioClient _dioClient;

  LeaveRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<LeaveBalance> getLeaveBalance() async {
    final response = await _dioClient.get(ApiEndpoints.leaveBalance);
    final map = response.data is Map ? response.data as Map : {};
    final data = map['data'] is Map ? map['data'] as Map<String, dynamic> : <String, dynamic>{};
    return LeaveBalanceModel.fromJson(data);
  }

  @override
  Future<List<LeaveRequest>> getLeaveRequests() async {
    final response = await _dioClient.get(ApiEndpoints.leaveRequests);
    final map = response.data is Map ? response.data as Map : {};
    final list = map['data'] is List ? map['data'] as List : [];
    return list
        .map((e) => LeaveRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<LeaveRequest> submitLeaveRequest({
    required String employeeId,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.leaveRequests,
      data: LeaveRequestModel.toJson(
        employeeId,
        leaveType,
        startDate,
        endDate,
        reason,
      ),
    );

    final map = response.data is Map ? response.data as Map : {};
    final data = map['data'] is Map ? map['data'] as Map<String, dynamic> : <String, dynamic>{};
    return LeaveRequestModel.fromJson(data);
  }
}
