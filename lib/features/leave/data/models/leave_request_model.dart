import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/leave_request.dart';

class LeaveRequestModel {
  static LeaveRequest fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      leaveRequestId: json['leaveRequestId'] as String? ?? json['id']?.toString() ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      leaveType: (json['leaveType'] as String? ?? 'CASUAL').toUpperCase(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : DateTime.now(),
      numberOfDays: (json['numberOfDays'] as num?)?.toInt() ?? 1,
    );
  }

  static LeaveRequest fromEntry(LeaveRequestEntry entry) {
    return LeaveRequest(
      id: entry.id,
      leaveRequestId: entry.leaveRequestId,
      employeeId: entry.employeeId,
      leaveType: entry.leaveType,
      startDate: entry.startDate,
      endDate: entry.endDate,
      reason: entry.reason,
      status: entry.status,
      submittedAt: entry.submittedAt,
      numberOfDays: entry.numberOfDays,
    );
  }

  static LeaveRequestTableCompanion toCompanion(LeaveRequest request) {
    return LeaveRequestTableCompanion.insert(
      leaveRequestId: request.leaveRequestId,
      employeeId: request.employeeId,
      leaveType: request.leaveType,
      startDate: request.startDate,
      endDate: request.endDate,
      reason: request.reason,
      status: Value(request.status),
      submittedAt: request.submittedAt,
      numberOfDays: request.numberOfDays,
      lastUpdated: DateTime.now(),
    );
  }

  static Map<String, dynamic> toJson(
    String employeeId,
    String leaveType,
    String startDate,
    String endDate,
    String reason,
  ) {
    return {
      'employeeId': employeeId,
      'leaveType': leaveType.toLowerCase(),
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
    };
  }
}
