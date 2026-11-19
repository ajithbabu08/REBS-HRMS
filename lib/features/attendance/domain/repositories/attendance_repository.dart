import '../entities/attendance_event.dart';
import '../entities/attendance_record.dart';

abstract class AttendanceRepository {
  /// Record a local attendance event (outbox).
  Future<AttendanceEvent> recordEventLocally(AttendanceEvent event);

  /// Synchronize a specific event immediately if online.
  Future<AttendanceEvent> syncEvent(AttendanceEvent event);

  /// Get today's attendance record (check-in + check-out pair) for an employee.
  Future<AttendanceRecord> getTodayAttendance(String employeeId, String todayDate);

  /// Watch today's attendance reactively.
  Stream<AttendanceRecord> watchTodayAttendance(String employeeId, String todayDate);

  /// Get attendance history for a specific month (YYYY-MM).
  Future<List<AttendanceRecord>> getAttendanceHistory(String employeeId, String month);

  /// Get recent attendance records (up to [limit]).
  Future<List<AttendanceRecord>> getRecentAttendance(String employeeId, {int limit = 5});

  /// Get count of pending sync events.
  Future<int> getPendingCount();

  /// Check if a check-in event exists for today.
  Future<AttendanceEvent?> getTodayCheckIn(String employeeId, String todayDate);

  /// Check if a check-out event exists for today.
  Future<AttendanceEvent?> getTodayCheckOut(String employeeId, String todayDate);
}
