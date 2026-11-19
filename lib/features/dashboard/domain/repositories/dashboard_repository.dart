import '../entities/dashboard_data.dart';
import '../entities/employee.dart';

abstract class DashboardRepository {
  /// Instantly get cached dashboard data from local SQLite (takes <5ms).
  Future<DashboardData> getLocalDashboardData(String employeeId, String todayDate);

  /// Fetch fresh data from remote in parallel, update local cache, and return.
  Future<DashboardData?> refreshDashboardData(String employeeId, String todayDate);

  /// Get dashboard data: local first, then refresh if online.
  Future<DashboardData> getDashboardData(String employeeId, String todayDate);

  /// Watch local SQLite changes reactively.
  Stream<DashboardData> watchDashboardData(String employeeId, String todayDate);

  /// Get employee profile.
  Future<Employee> getEmployeeProfile(String employeeId);
}
