import 'package:equatable/equatable.dart';
import 'employee.dart';
import '../../../leave/domain/entities/leave_balance.dart';
import '../../../attendance/domain/entities/attendance_record.dart';

class DashboardData extends Equatable {
  final Employee employee;
  final AttendanceRecord todayAttendance;
  final LeaveBalance leaveBalance;
  final List<AttendanceRecord> recentAttendance;
  final int pendingEventsCount;
  final bool isOffline;

  const DashboardData({
    required this.employee,
    required this.todayAttendance,
    required this.leaveBalance,
    required this.recentAttendance,
    this.pendingEventsCount = 0,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [
        employee,
        todayAttendance,
        leaveBalance,
        recentAttendance,
        pendingEventsCount,
        isOffline,
      ];
}
