import 'package:equatable/equatable.dart';

class LeaveRequest extends Equatable {
  final int? id;
  final String leaveRequestId;
  final String employeeId;
  final String leaveType; // CASUAL, SICK
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // PENDING, APPROVED, REJECTED
  final DateTime submittedAt;
  final int numberOfDays;

  const LeaveRequest({
    this.id,
    required this.leaveRequestId,
    required this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.submittedAt,
    required this.numberOfDays,
  });

  bool get isPending => status == 'PENDING';
  bool get isApproved => status == 'APPROVED';
  bool get isRejected => status == 'REJECTED';

  @override
  List<Object?> get props => [
        id,
        leaveRequestId,
        employeeId,
        leaveType,
        startDate,
        endDate,
        reason,
        status,
        submittedAt,
        numberOfDays,
      ];
}
